DELIMITER $$
CREATE TRIGGER Check_ExistOrderLoc
BEFORE DELETE ON locations
FOR EACH ROW
BEGIN
    -- Logic: Kiểm tra xem có bất kỳ Order nào thuộc Location này
    -- có trạng thái là PENDING, CONFIRMED hoặc COMPLETED hay không.
    -- (Lưu ý: Bảng ORDERS có cột venue_loc_id chính là location_id nên không cần join bảng VENUES)
    
    IF EXISTS (
        SELECT 1 
        FROM orders o
        WHERE o.venue_loc_id = OLD.location_id
          AND o.status IN ('PENDING', 'CONFIRMED', 'COMPLETED')
    ) THEN
        SIGNAL SQLSTATE '45117' 
        SET MESSAGE_TEXT = 'Error: Cannot delete Location. It contains venues with associated booking history (Pending, Confirmed, or Completed). Please deactivate (Soft Delete) instead.';
    END IF;
END$$

DELIMITER ;