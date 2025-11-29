-- venue
DELIMITER $$
CREATE TRIGGER Update_VenueActive
AFTER UPDATE ON locations
FOR EACH ROW
BEGIN
    -- Nếu Location bị chuyển sang Inactive
    IF NEW.isActive = 0 AND OLD.isActive = 1 THEN
        UPDATE venues
        SET isActive = 0
        WHERE location_id = NEW.location_id;
    END IF;
    
    -- (Tùy chọn) Nếu Location mở lại, có thể bạn KHÔNG muốn tự động mở lại tất cả phòng 
    -- (vì có thể phòng đó đang sửa chữa thật), nên chỉ cần xử lý chiều khóa đi là an toàn nhất.
END$$
DELIMITER ;