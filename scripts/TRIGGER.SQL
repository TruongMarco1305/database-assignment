-- AMENITY
-- 1. Đổi dấu kết thúc từ ';' sang '$$'
DELIMITER $$

-- 2. Bắt đầu viết Trigger.
-- MySQL sẽ đọc tất cả các dòng dưới đây như một khối văn bản duy nhất.
-- Nó GẶP dấu ';' ở dòng UPDATE, nhưng nó BỎ QUA (không chạy ngay).
CREATE TRIGGER Before_Venue_Delete
BEFORE DELETE ON VENUES
FOR EACH ROW
BEGIN
    -- Cập nhật bảng Amenities: Set tên phòng về NULL và chuyển trạng thái về STORAGE
    UPDATE AMENITIES
    SET venueName = NULL, 
        status = 'STORAGE' -- Tự động cập nhật trạng thái luôn cho hợp lý
    WHERE location_id = OLD.location_id 
      AND venueName = OLD.name;
END$$ -- 3. Gặp dấu '$$', MySQL hiểu là "Hết bài", giờ mới bắt đầu biên dịch và tạo Trigger.

-- 4. Đổi dấu kết thúc trở lại thành ';' như bình thường để chạy các lệnh khác sau này
DELIMITER ;

-- rate

CREATE TRIGGER trg_Rate_Insert
AFTER INSERT ON rates
FOR EACH ROW
BEGIN
    UPDATE locations
    SET avgRating = (
        SELECT IFNULL(AVG(stars), 0) 
        FROM rates 
        WHERE location_id = NEW.location_id
    )
    WHERE location_id = NEW.location_id;
END