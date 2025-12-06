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

-- function phức tạp
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
    DECLARE v_orderPrice DECIMAL(12, 2);

    -- Biến kiểm tra tồn tại
    DECLARE v_ownerExists INT;
    DECLARE v_joinDate DATETIME;
    
    -- Biến theo dõi doanh thu tích lũy
    DECLARE v_revenue_OLD DECIMAL(15, 2) DEFAULT 0;
    DECLARE v_revenue_NEW DECIMAL(15, 2) DEFAULT 0;
    
    -- Biến tính phí tích lũy
    DECLARE v_fee_OLD DECIMAL(15, 2) DEFAULT 0;
    DECLARE v_fee_NEW DECIMAL(15, 2) DEFAULT 0;
    
    DECLARE v_totalCommission DECIMAL(15, 2) DEFAULT 0;
    
    -- 2. Cursor: Lấy tất cả đơn hàng hoàn tất của Owner (từ mọi Location)
    DECLARE cur_orders CURSOR FOR 
        SELECT o.totalPrice
        FROM orders o
        JOIN venues v ON o.venue_loc_id = v.location_id AND o.venueName = v.name
        JOIN locations l ON v.location_id = l.location_id
        WHERE l.owner_id = v_owner_uuid
          AND o.status = 'COMPLETED'
          AND MONTH(o.endHour) = p_month
          AND YEAR(o.endHour) = p_year
        ORDER BY o.createdAt ASC; -- Duyệt theo thời gian để tính lũy tiến chính xác

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- 3. Validate
    -- A. Kiểm tra Tháng/Năm hợp lệ
    IF p_month < 1 OR p_month > 12 THEN 
        RETURN NULL; -- Tháng sai
    END IF;

    -- B. Kiểm tra Owner có tồn tại không
    -- (Lưu ý: Phải convert trước khi select)
    SET v_owner_uuid = UUID_TO_BIN(p_ownerId);

    SELECT COUNT(*), MAX(u.createdAt) INTO v_ownerExists, v_joinDate
    FROM owners o
    JOIN users u ON o.user_id = u.id
    WHERE o.user_id = v_owner_uuid;

    IF v_ownerExists = 0 THEN
        RETURN NULL; -- Owner không tồn tại
    END IF;

    -- C. Kiểm tra Logic thời gian tham gia (Optional)
    -- Nếu tháng tính phí nhỏ hơn tháng tham gia hệ thống -> Trả về 0
    IF (p_year * 12 + p_month) < (YEAR(v_joinDate) * 12 + MONTH(v_joinDate)) THEN
        RETURN 0;
    END IF;

    -- 4. Duyệt và Tính toán
    OPEN cur_orders;

    read_loop: LOOP
        FETCH cur_orders INTO v_orderPrice;
        IF done THEN LEAVE read_loop; END IF;

        -- Cập nhật trạng thái doanh thu
        SET v_revenue_NEW = v_revenue_OLD + v_orderPrice;

        -- A. Tính tổng phí cho mức doanh thu CŨ
        SET v_fee_OLD = CASE 
            WHEN v_revenue_OLD <= 5000000 THEN 0
            WHEN v_revenue_OLD <= 10000000 THEN (v_revenue_OLD - 5000000) * 0.10
            WHEN v_revenue_OLD <= 50000000 THEN 500000 + (v_revenue_OLD - 10000000) * 0.08
            ELSE 3700000 + (v_revenue_OLD - 50000000) * 0.05
        END;

        -- B. Tính tổng phí cho mức doanh thu MỚI
        SET v_fee_NEW = CASE 
            WHEN v_revenue_NEW <= 5000000 THEN 0
            WHEN v_revenue_NEW <= 10000000 THEN (v_revenue_NEW - 5000000) * 0.10
            WHEN v_revenue_NEW <= 50000000 THEN 500000 + (v_revenue_NEW - 10000000) * 0.08
            ELSE 3700000 + (v_revenue_NEW - 50000000) * 0.05
        END;

        -- Phí của đơn hàng này = Chênh lệch
        SET v_totalCommission = v_totalCommission + (v_fee_NEW - v_fee_OLD);
        
        -- Gán lại cho vòng lặp sau
        SET v_revenue_OLD = v_revenue_NEW;
        
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
        SIGNAL SQLSTATE '45004' SET MESSAGE_TEXT = 'Error: locationId is required.';
    END IF;
    
    SET v_loc_uuid = UUID_TO_BIN(p_locationId);
    
    IF v_loc_uuid IS NULL OR NOT EXISTS (SELECT 1 FROM locations WHERE location_id = v_loc_uuid) THEN
        SIGNAL SQLSTATE '45005' SET MESSAGE_TEXT = 'Error: Location not found or invalid locationId.';
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