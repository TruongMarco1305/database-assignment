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

    -- 2. Validate Price (Nếu có truyền vào)
    IF p_totalPrice IS NOT NULL AND p_totalPrice < 0 THEN
        SIGNAL SQLSTATE '45131' SET MESSAGE_TEXT = 'Error: Total Price cannot be negative.';
    END IF;

    -- 3. Validate Points (Nếu có truyền vào)
    IF p_points IS NOT NULL AND p_points < 0 THEN
        SIGNAL SQLSTATE '45132' SET MESSAGE_TEXT = 'Error: Points cannot be negative.';
    END IF;

    -- 4. Validate Status (Nếu có truyền vào)
    -- Đã thêm 'CANCELLED' vào danh sách cho phép
    IF p_status IS NOT NULL AND p_status NOT IN ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED') THEN
        SIGNAL SQLSTATE '45133' SET MESSAGE_TEXT = 'Error: Invalid status value.';
    END IF;

    -- 5. Execute Update (Partial Update)
    -- Cập nhật trực tiếp, bao gồm cả trạng thái CANCELLED
    UPDATE orders 
    SET 
        totalPrice = COALESCE(p_totalPrice, totalPrice),
        points     = COALESCE(p_points, points),
        status     = COALESCE(p_status, status)
    WHERE order_id = v_id;
END$$

CREATE PROCEDURE Order_Cancel(
    IN p_orderId VARCHAR(36),
    IN p_cancelReason TEXT
)
BEGIN
    DECLARE v_orderBin BINARY(16);
    DECLARE v_invoiceBin BINARY(16);
    DECLARE exit handler for sqlexception
    BEGIN
        -- Rollback if any error occurs
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Transaction failed. Order not cancelled.';
    END;

    SET v_orderBin = UUID_TO_BIN(p_orderId);

    -- 1. Validations
    -- Check if Order Exists
    IF NOT EXISTS (SELECT 1 FROM orders WHERE order_id = v_orderBin) THEN
        SIGNAL SQLSTATE '45059' SET MESSAGE_TEXT = 'Error: Order does not exist.';
    END IF;

    -- Optional: Check if Order is already Completed (Cannot cancel a completed order)
    IF EXISTS (SELECT 1 FROM orders WHERE order_id = v_orderBin AND status = 'COMPLETED') THEN
        SIGNAL SQLSTATE '45060' SET MESSAGE_TEXT = 'Error: Cannot cancel a COMPLETED order.';
    END IF;

    -- 2. Start Atomic Transaction
    START TRANSACTION;

        -- A. Update Order Status to CANCELLED
        UPDATE orders 
        SET status = 'CANCELLED'
        WHERE order_id = v_orderBin;

        -- B. Update Invoice Status to FAILED
        -- logic: We find the invoice associated with this order
        -- If no invoice exists (e.g., cancelled before payment created), this simply affects 0 rows, which is fine.
        UPDATE invoices 
        SET 
            status = 'FAILED', 
            description = CONCAT('Order Cancelled. Reason: ', COALESCE(p_cancelReason, 'User Request'))
        WHERE order_id = v_orderBin; 
        -- NOTE: Ensure your 'invoices' table has an 'order_id' column. 
        -- If your relationship is different (e.g. order has invoice_id), you must SELECT the invoice_id first.

    -- 3. Commit Changes
    COMMIT;
    
END$$
DELIMITER ;
