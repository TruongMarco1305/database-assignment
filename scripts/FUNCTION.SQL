-- function cơ bản
DELIMITER $$
CREATE FUNCTION Cal_Age(birthDate DATE)
RETURNS INT
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
DELIMITER $$
CREATE FUNCTION Calc_OwnerRevenue(
    p_ownerId VARCHAR(36),
    p_startDate DATETIME,
    p_endDate DATETIME
)
RETURNS DECIMAL(15, 2)
READS SQL DATA
BEGIN
    -- 1. Khai báo biến
    DECLARE v_totalRevenue DECIMAL(15, 2) DEFAULT 0;
    DECLARE v_amount DECIMAL(12, 2);
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_owner_uuid BINARY(16);

    -- 2. Khai báo Cursor: Lấy danh sách tiền từ các hóa đơn thành công
    -- Join từ: Owner -> Location -> Venue -> Order -> Invoice
    DECLARE cur_invoices CURSOR FOR 
        SELECT i.amount
        FROM invoices i
        JOIN orders o ON i.order_id = o.order_id
        JOIN venues v ON o.venue_loc_id = v.location_id AND o.venueName = v.name
        JOIN locations l ON v.location_id = l.location_id
        WHERE l.owner_id = v_owner_uuid
          AND i.status = 'SUCCEEDED'
          AND i.paidOn BETWEEN p_startDate AND p_endDate;

    -- 3. Khai báo Handler để nhận biết khi nào hết dữ liệu
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- 4. Validate Input
    IF p_startDate IS NULL OR p_endDate IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: startDate and endDate must be provided.';
    END IF;

    IF p_startDate >= p_endDate THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: startDate must be earlier than endDate.';
    END IF;

    SET v_owner_uuid = UUID_TO_BIN(p_ownerId);

    IF v_owner_uuid IS NULL OR NOT EXISTS (SELECT 1 FROM owners WHERE user_id = v_owner_uuid) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Owner not found or invalid ownerId.';
    END IF;

    -- 5. Mở Cursor và lặp
    SET done = FALSE;
    OPEN cur_invoices;

    read_loop: LOOP
        FETCH cur_invoices INTO v_amount;
        
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Cộng dồn doanh thu
        SET v_totalRevenue = v_totalRevenue + v_amount;
    END LOOP;

    CLOSE cur_invoices;

    RETURN v_totalRevenue;
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