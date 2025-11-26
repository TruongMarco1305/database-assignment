-- venue images
DELIMITER $$

-- 1. Insert Venue Image
CREATE PROCEDURE VenueImage_Insert(
    IN p_id VARCHAR(36),       -- ID của ảnh (tạo mới từ code)
    IN p_locId VARCHAR(36),    -- ID của địa điểm
    IN p_venueName VARCHAR(100), -- Tên phòng
    IN p_url VARCHAR(255)      -- Link ảnh
)
BEGIN
    INSERT INTO venue_images (image_id, location_id, venueName, locationImgURL)
    VALUES (UUID_TO_BIN(p_id), UUID_TO_BIN(p_locId), p_venueName, p_url);
END$$

-- 2. Update Venue Image
-- Thường chỉ cần sửa đường dẫn ảnh (URL). 
-- Nếu muốn đổi ảnh sang phòng khác, nên Xóa đi tạo lại thay vì Update khóa ngoại.
CREATE PROCEDURE VenueImage_Update(
    IN p_id VARCHAR(36),
    IN p_url VARCHAR(255)
)
BEGIN
    UPDATE venue_images 
    SET locationImgURL = p_url
    WHERE image_id = UUID_TO_BIN(p_id);
END$$

-- 3. Delete Venue Image
CREATE PROCEDURE VenueImage_Delete(IN p_id VARCHAR(36))
BEGIN
    DELETE FROM venue_images WHERE image_id = UUID_TO_BIN(p_id);
END$$

DELIMITER ;
