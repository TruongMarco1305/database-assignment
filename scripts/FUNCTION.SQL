-- function cơ bản
DELIMITER $$
CREATE FUNCTION Cal_Age(birthDate DATE)
RETURNS INT
NOT DETERMINISTIC
BEGIN
    -- Tính số năm chênh lệch giữa ngày sinh và ngày hiện tại
    RETURN TIMESTAMPDIFF(YEAR, birthDate, CURDATE());
END$$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION Get_Tier(p_points INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    -- Logic quy đổi điểm (có thể sửa mốc điểm)
    IF p_points >= 5000 THEN
        RETURN 'PLATINUM';
    ELSEIF p_points >= 2000 THEN
        RETURN 'GOLD';
    ELSEIF p_points >= 500 THEN
        RETURN 'SILVER';
    ELSE
        RETURN 'BRONZE';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION Calc_TotalPrice(
    p_locId BINARY(16),
    p_venueName VARCHAR(100),
    p_start DATETIME,
    p_end DATETIME
)
RETURNS DECIMAL(12, 2)
READS SQL DATA
BEGIN
    DECLARE v_pricePerHour DECIMAL(10,2);
    DECLARE v_hours INT;
    DECLARE v_total DECIMAL(12,2);

    IF p_start IS NULL OR p_end IS NULL THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid dates'; 
    END IF;

    IF p_start >= p_end THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='start must be before end'; 
    END IF;

    -- 1. Lấy giá phòng
    SELECT pricePerHour INTO v_pricePerHour
    FROM venues 
    WHERE location_id = p_locId AND name = p_venueName;

    -- Nếu không tìm thấy phòng (phòng sai tên hoặc id), trả về 0 hoặc báo lỗi
    IF v_pricePerHour IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Venue not found';
    END IF;

    -- 2. Tính số giờ (Làm tròn logic như cũ)
    SET v_hours = TIMESTAMPDIFF(HOUR, p_start, p_end);
    IF v_hours <= 0 THEN SET v_hours = 1; END IF;

    -- 3. Tính tổng tiền
    SET v_total = v_pricePerHour * v_hours;

    RETURN v_total;
END$$

DELIMITER ;

-- function phức tạp
-- DELIMITER $$
-- CREATE FUNCTION Calc_OwnerRevenue(
--     p_ownerId VARCHAR(36),
--     p_startDate DATETIME,
--     p_endDate DATETIME
-- )
-- RETURNS DECIMAL(15, 2)
-- READS SQL DATA
-- BEGIN
--     -- 1. Khai báo biến
--     DECLARE v_totalRevenue DECIMAL(15, 2) DEFAULT 0;
--     DECLARE v_amount DECIMAL(12, 2);
--     DECLARE done INT DEFAULT FALSE;
--     DECLARE v_owner_uuid BINARY(16);

--     -- 2. Khai báo Cursor: Lấy danh sách tiền từ các hóa đơn thành công
--     -- Join từ: Owner -> Location -> Venue -> Order -> Invoice
--     DECLARE cur_invoices CURSOR FOR 
--         SELECT i.amount
--         FROM invoices i
--         JOIN orders o ON i.order_id = o.order_id
--         JOIN venues v ON o.venue_loc_id = v.location_id AND o.venueName = v.name
--         JOIN locations l ON v.location_id = l.location_id
--         WHERE l.owner_id = v_owner_uuid
--           AND i.status = 'SUCCEEDED'
--           AND i.paidOn BETWEEN p_startDate AND p_endDate;

--     -- 3. Khai báo Handler để nhận biết khi nào hết dữ liệu
--     DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

--     -- 4. Validate Input
--     IF p_startDate IS NULL OR p_endDate IS NULL THEN
--         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: startDate and endDate must be provided.';
--     END IF;

--     IF p_startDate >= p_endDate THEN
--         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: startDate must be earlier than endDate.';
--     END IF;

--     SET v_owner_uuid = UUID_TO_BIN(p_ownerId);

--     IF v_owner_uuid IS NULL OR NOT EXISTS (SELECT 1 FROM owners WHERE user_id = v_owner_uuid) THEN
--         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Owner not found or invalid ownerId.';
--     END IF;

--     -- 5. Mở Cursor và lặp
--     SET done = FALSE;
--     OPEN cur_invoices;

--     read_loop: LOOP
--         FETCH cur_invoices INTO v_amount;
        
--         IF done THEN
--             LEAVE read_loop;
--         END IF;

--         -- Cộng dồn doanh thu
--         SET v_totalRevenue = v_totalRevenue + v_amount;
--     END LOOP;

--     CLOSE cur_invoices;

--     RETURN v_totalRevenue;
-- END$$

-- DELIMITER ;

DELIMITER $$
CREATE FUNCTION Calc_OwnerFee(
    p_ownerId VARCHAR(36),
    p_month INT,
    p_year INT
)
RETURNS DECIMAL(15, 2)
DETERMINISTIC
READS SQL DATA
BEGIN
    -- 1. Khai báo biến
    DECLARE v_owner_uuid BINARY(16);
    DECLARE done INT DEFAULT FALSE;
    
    -- Biến cho từng dòng đơn hàng
    DECLARE v_orderPrice DECIMAL(12, 2);
    
    -- Biến theo dõi trạng thái tích lũy (Quan trọng)
    DECLARE v_runningRevenue DECIMAL(15, 2) DEFAULT 0; -- Doanh thu tích lũy trước đơn hiện tại
    DECLARE v_newRevenue DECIMAL(15, 2) DEFAULT 0;     -- Doanh thu tích lũy sau đơn hiện tại
    
    -- Biến tính toán
    DECLARE v_totalCommission DECIMAL(15, 2) DEFAULT 0;
    DECLARE v_orderCommission DECIMAL(12, 2) DEFAULT 0;
    
    -- Các mốc giới hạn (Hardcode hoặc lấy từ bảng cấu hình)
    DECLARE C_LIMIT_1 DECIMAL(15, 2) DEFAULT 10000000;
    DECLARE C_LIMIT_2 DECIMAL(15, 2) DEFAULT 50000000;
    
    -- 2. Khai báo Cursor: Lấy danh sách tiền của các đơn hàng ĐÃ HOÀN THÀNH trong tháng
    DECLARE cur_orders CURSOR FOR 
        SELECT o.totalPrice
        FROM orders o
        JOIN venues v ON o.venue_loc_id = v.location_id AND o.venueName = v.name
        JOIN locations l ON v.location_id = l.location_id
        WHERE l.owner_id = v_owner_uuid
          AND MONTH(o.createdAt) = p_month
          AND YEAR(o.createdAt) = p_year
          AND o.status = 'COMPLETED' -- Chỉ tính đơn đã hoàn thành
        ORDER BY o.createdAt ASC;    -- Quan trọng: Phải duyệt theo thứ tự thời gian

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- 3. Validate Input
    IF p_month < 1 OR p_month > 12 THEN RETURN 0; END IF;
    SET v_owner_uuid = UUID_TO_BIN(p_ownerId);

    -- 4. Mở Cursor và duyệt
    OPEN cur_orders;

    read_loop: LOOP
        FETCH cur_orders INTO v_orderPrice;
        
        IF done THEN LEAVE read_loop; END IF;

        -- Tính toán "Vị trí" của đơn hàng này trong dòng doanh thu
        SET v_newRevenue = v_runningRevenue + v_orderPrice;
        SET v_orderCommission = 0;

        -- --- LOGIC TÍNH HOA HỒNG LŨY TIẾN (IF lồng nhau) ---
        
        -- Giai đoạn 1: Toàn bộ đơn hàng nằm trong khoảng 0 - 10tr
        IF v_newRevenue <= C_LIMIT_1 THEN
            SET v_orderCommission = v_orderPrice * 0.10;
            
        -- Giai đoạn 2: Đơn hàng vắt qua mốc 10tr (Một phần 10%, một phần 8%)
        ELSEIF v_runningRevenue < C_LIMIT_1 AND v_newRevenue <= C_LIMIT_2 THEN
            -- Phần chịu 10%
            SET v_orderCommission = (C_LIMIT_1 - v_runningRevenue) * 0.10;
            -- Phần chịu 8%
            SET v_orderCommission = v_orderCommission + (v_newRevenue - C_LIMIT_1) * 0.08;
            
        -- Giai đoạn 3: Toàn bộ đơn hàng nằm trong khoảng 10tr - 50tr
        ELSEIF v_runningRevenue >= C_LIMIT_1 AND v_newRevenue <= C_LIMIT_2 THEN
            SET v_orderCommission = v_orderPrice * 0.08;
            
        -- Giai đoạn 4: Đơn hàng vắt qua mốc 50tr (Một phần 8%, một phần 5%)
        ELSEIF v_runningRevenue < C_LIMIT_2 AND v_newRevenue > C_LIMIT_2 THEN
            -- Trường hợp đặc biệt: Đơn hàng khủng, vắt qua cả 2 mốc (từ dưới 10tr lên trên 50tr)
            IF v_runningRevenue < C_LIMIT_1 THEN
                 SET v_orderCommission = (C_LIMIT_1 - v_runningRevenue) * 0.10; -- Khúc đầu
                 SET v_orderCommission = v_orderCommission + (C_LIMIT_2 - C_LIMIT_1) * 0.08; -- Khúc giữa
                 SET v_orderCommission = v_orderCommission + (v_newRevenue - C_LIMIT_2) * 0.05; -- Khúc đuôi
            ELSE
                -- Vắt qua mốc 50tr bình thường
                SET v_orderCommission = (C_LIMIT_2 - v_runningRevenue) * 0.08;
                SET v_orderCommission = v_orderCommission + (v_newRevenue - C_LIMIT_2) * 0.05;
            END IF;
            
        -- Giai đoạn 5: Toàn bộ đơn hàng nằm trên mốc 50tr
        ELSE
            SET v_orderCommission = v_orderPrice * 0.05;
        END IF;

        -- Cộng dồn vào tổng hoa hồng
        SET v_totalCommission = v_totalCommission + v_orderCommission;
        
        -- Cập nhật doanh thu tích lũy để dùng cho vòng lặp sau
        SET v_runningRevenue = v_newRevenue;
        
    END LOOP;

    CLOSE cur_orders;

    RETURN v_totalCommission;
END$$

DELIMITER ;

DELIMITER $$
CREATE FUNCTION GetLocationStatusReport(
    p_locationId VARCHAR(36)
)
RETURNS TEXT
READS SQL DATA
BEGIN
    -- 1. Khai báo biến
    DECLARE v_report TEXT DEFAULT '';
    DECLARE v_venueName VARCHAR(100);
    DECLARE v_status VARCHAR(20);
    DECLARE v_isBusy INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_loc_uuid BINARY(16);

    -- 2. Khai báo Cursor: Lấy danh sách tên các phòng trong Location
    DECLARE cur_venues CURSOR FOR 
        SELECT name 
        FROM venues 
        WHERE location_id = v_loc_uuid
        ORDER BY name;

    -- 3. Handler kết thúc loop
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- 4. Validate Input
    IF p_locationId IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: locationId is required.';
    END IF;
    
    SET v_loc_uuid = UUID_TO_BIN(p_locationId);
    
    IF v_loc_uuid IS NULL OR NOT EXISTS (SELECT 1 FROM locations WHERE location_id = v_loc_uuid) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Location not found or invalid locationId.';
    END IF;

    -- 5. Mở Cursor
    SET done = FALSE;
    OPEN cur_venues;

    -- Khởi tạo tiêu đề báo cáo
    SET v_report = CONCAT('Status Report for Location (', p_locationId, ') at (', NOW(), '): \n');

    read_loop: LOOP
        FETCH cur_venues INTO v_venueName;
        
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Logic kiểm tra xem phòng có đang bận không
        -- Phòng bận nếu có đơn hàng CONFIRMED hoặc PENDING mà (Start <= NOW <= End)
        SELECT COUNT(*) INTO v_isBusy
        FROM orders
        WHERE venue_loc_id = v_loc_uuid 
          AND venueName = v_venueName
          AND status IN ('CONFIRMED', 'PENDING')
          AND NOW() BETWEEN startHour AND endHour;

        IF v_isBusy > 0 THEN
            SET v_status = 'BUSY';
        ELSE
            SET v_status = 'AVAILABLE';
        END IF;

        -- Nối chuỗi kết quả
        SET v_report = CONCAT(v_report, '- ', v_venueName, ': ', v_status, '\n');
        
    END LOOP;

    CLOSE cur_venues;

    RETURN v_report;
END$$

DELIMITER ;