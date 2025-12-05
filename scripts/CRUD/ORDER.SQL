-- order
DELIMITER $$

    -- Insert Order
    CREATE PROCEDURE Order_Insert(
        IN p_id VARCHAR(36),
        IN p_clientId VARCHAR(36),
        IN p_locId VARCHAR(36),
        IN p_venueName VARCHAR(100),
        -- BỎ p_totalPrice và p_points
        IN p_start DATETIME,
        IN p_end DATETIME
    )
    BEGIN
        -- Validate giờ giấc cơ bản trước khi Insert
        IF p_end <= p_start THEN
            SIGNAL SQLSTATE '45055' SET MESSAGE_TEXT = 'Error: End time must be after Start time.';
        END IF;

        -- Thêm vào Order_Insert
        IF p_start < DATE_ADD(NOW(), INTERVAL 4 HOUR) THEN
            SIGNAL SQLSTATE '45056' SET MESSAGE_TEXT = 'Error: Bookings must be made at least 4 hours in advance.';
        END IF;

        -- Validation: Kiểm tra Client và Venue tồn tại (Foreign Key Check)
        IF NOT EXISTS (SELECT 1 FROM clients WHERE user_id = UUID_TO_BIN(p_clientId)) THEN
            SIGNAL SQLSTATE '45057' SET MESSAGE_TEXT = 'Error: Client does not exist.';
        END IF;
        
        IF NOT EXISTS (SELECT 1 FROM venues WHERE location_id = UUID_TO_BIN(p_locId) AND name = p_venueName) THEN
            SIGNAL SQLSTATE '45058' SET MESSAGE_TEXT = 'Error: Venue does not exist.';
        END IF;

        INSERT INTO orders (
            order_id, client_id, venue_loc_id, venueName, 
            totalPrice, -- Cột này NOT NULL nên phải truyền
            points,     -- Cột này NOT NULL nên phải truyền
            startHour, endHour, expiredAt
        )
        VALUES (
            UUID_TO_BIN(p_id), 
            UUID_TO_BIN(p_clientId), 
            UUID_TO_BIN(p_locId), 
            p_venueName, 
            0, -- Truyền số 0 giả (Trigger sẽ sửa lại thành tiền thật)
            0, -- Truyền số 0 giả (Trigger sẽ sửa lại thành điểm thật)
            p_start, 
            p_end, 
            DATE_ADD(NOW(), INTERVAL 15 MINUTE)
        );
    END$$
    DELIMITER ;

-- Update Order
DELIMITER $$
CREATE PROCEDURE Order_Update(
    IN p_id VARCHAR(36),
    IN p_totalPrice DECIMAL(12,2), -- Truyền NULL nếu không sửa
    IN p_points INT,               -- Truyền NULL nếu không sửa
    IN p_status VARCHAR(20)        -- Truyền NULL nếu không sửa ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED')
)
BEGIN
    DECLARE v_id BINARY(16);
    SET v_id = UUID_TO_BIN(p_id);

    -- 1. Check Existence
    IF NOT EXISTS (SELECT 1 FROM orders WHERE order_id = v_id) THEN
        SIGNAL SQLSTATE '45059' SET MESSAGE_TEXT = 'Error: Order does not exist.';
    END IF;

    -- 2. LOGIC MỚI: Nếu trạng thái là CANCELLED -> Gọi xóa luôn
    IF p_status = 'CANCELLED' THEN
        CALL Order_Delete(p_id);
    ELSE
        -- Các logic Update bình thường
        
        -- Validate
        IF p_totalPrice IS NOT NULL AND p_totalPrice < 0 THEN
            SIGNAL SQLSTATE '45060' SET MESSAGE_TEXT = 'Error: Total Price cannot be negative.';
        END IF;

        IF p_points IS NOT NULL AND p_points < 0 THEN
            SIGNAL SQLSTATE '45061' SET MESSAGE_TEXT = 'Error: Points cannot be negative.';
        END IF;

        IF p_status IS NOT NULL AND p_status NOT IN ('PENDING', 'CONFIRMED', 'COMPLETED') THEN
            SIGNAL SQLSTATE '45062' SET MESSAGE_TEXT = 'Error: Invalid status value.';
        END IF;

        -- Execute Update
        UPDATE orders 
        SET 
            totalPrice = COALESCE(p_totalPrice, totalPrice),
            points     = COALESCE(p_points, points),
            status     = COALESCE(p_status, status)
        WHERE order_id = v_id;
    END IF;
END$$
DELIMITER ;

-- Delete Order
DELIMITER $$
CREATE PROCEDURE Order_Delete(IN p_id VARCHAR(36))
BEGIN
    DECLARE v_id BINARY(16);
    SET v_id = UUID_TO_BIN(p_id);

    -- 1. Check Existence
    IF NOT EXISTS (SELECT 1 FROM orders WHERE order_id = v_id) THEN
        SIGNAL SQLSTATE '45063' SET MESSAGE_TEXT = 'Error: Order does not exist.';
    END IF;

    -- 2. Constraint Check: INVOICE
    -- Không cho xóa đơn hàng đã xuất hóa đơn (đảm bảo tính toàn vẹn tài chính)
    IF EXISTS (SELECT 1 FROM invoices WHERE order_id = v_id) THEN
        SIGNAL SQLSTATE '45064' SET MESSAGE_TEXT = 'Error: Cannot delete Order. An Invoice has been generated.';
    END IF;

    DELETE FROM orders WHERE order_id = v_id;
END$$

DELIMITER ;