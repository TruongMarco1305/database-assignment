DELIMITER $$
CREATE TRIGGER Check_DeactiveAme
BEFORE UPDATE ON amenities
FOR EACH ROW
BEGIN
    -- Nếu đang chuyển sang Inactive (0)
    IF OLD.isActive = 1 AND NEW.isActive = 0 THEN
        
        -- Kiểm tra xem Amenity này có đang gắn với đơn hàng nào đang chạy không
        IF EXISTS (
            SELECT 1 
            FROM order_amenities oa
            JOIN orders o ON oa.order_id = o.order_id
            WHERE oa.amenity_id = OLD.amenity_id
              AND o.status IN ('PENDING', 'CONFIRMED')
              AND o.endHour > NOW()
        ) THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Error: Cannot deactivate Amenity. It is currently assigned to an active order.';
        END IF;
        
    END IF;
END$$

DELIMITER ;