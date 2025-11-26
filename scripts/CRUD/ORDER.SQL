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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: End time must be after Start time.';
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

-- Update Order Status
CREATE PROCEDURE Order_UpdateStatus(
    IN p_id VARCHAR(36),
    IN p_status VARCHAR(20) -- 'CONFIRMED', 'CANCELLED'
)
BEGIN
    UPDATE orders SET status = p_status WHERE order_id = UUID_TO_BIN(p_id);
END$$

-- Delete Order
CREATE PROCEDURE Order_Delete(IN p_id VARCHAR(36))
BEGIN
    DELETE FROM orders WHERE order_id = UUID_TO_BIN(p_id);
END$$

DELIMITER ;