DELIMITER $$
CREATE TRIGGER Check_ExistOrderVen
BEFORE DELETE ON venues
FOR EACH ROW
BEGIN
    -- Logic: Kiểm tra xem phòng này có bất kỳ đơn hàng nào (kể cả đã hoàn thành)
    -- Nếu có -> Báo lỗi, không cho xóa.
    IF EXISTS (
        SELECT 1 
        FROM orders o
        WHERE o.venue_loc_id = OLD.location_id 
          AND o.venueName = OLD.name
          AND o.status IN ('PENDING', 'CONFIRMED', 'COMPLETED')
    ) THEN
        SIGNAL SQLSTATE '45123' 
        SET MESSAGE_TEXT = 'Error: Cannot delete Venue. It has associated bookings history (Pending, Confirmed, or Completed). Please deactivate it instead.';
    END IF;
END$$

DELIMITER ;