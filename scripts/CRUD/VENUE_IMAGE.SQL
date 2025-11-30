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
    DECLARE v_locId BINARY(16);
    SET v_locId = UUID_TO_BIN(p_locId);

    -- 1. Validate URL
    IF p_url IS NULL OR p_url = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Image URL cannot be empty.';
    END IF;

    -- 2. Validate Foreign Key (Venue Existence)
    -- Phải kiểm tra cả cặp (location_id, venueName) vì đây là composite key
    IF NOT EXISTS (
        SELECT 1 FROM venues 
        WHERE location_id = v_locId AND name = p_venueName
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Venue does not exist.';
    END IF;

    INSERT INTO venue_images (image_id, location_id, venueName, locationImgURL)
    VALUES (UUID_TO_BIN(p_id), v_locId, p_venueName, p_url);
END$$

-- 2. Update Venue Image
-- Thường chỉ cần sửa đường dẫn ảnh (URL). 
-- Nếu muốn đổi ảnh sang phòng khác, nên Xóa đi tạo lại thay vì Update khóa ngoại.
CREATE PROCEDURE VenueImage_Update(
    IN p_id VARCHAR(36),
    IN p_url VARCHAR(255)
)
BEGIN
    DECLARE v_id BINARY(16);
    SET v_id = UUID_TO_BIN(p_id);

    -- 1. Check Existence
    IF NOT EXISTS (SELECT 1 FROM venue_images WHERE image_id = v_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Image does not exist.';
    END IF;

    -- 2. Validate URL (Nếu có truyền vào)
    IF p_url IS NOT NULL AND p_url = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Image URL cannot be empty.';
    END IF;

    -- Execute Update (Partial Update)
    UPDATE venue_images 
    SET locationImgURL = COALESCE(p_url, locationImgURL)
    WHERE image_id = v_id;
END$$

-- 3. Delete Venue Image
CREATE PROCEDURE VenueImage_Delete(IN p_id VARCHAR(36))
BEGIN
    DECLARE v_id BINARY(16);
    SET v_id = UUID_TO_BIN(p_id);

    -- 1. Check Existence
    IF NOT EXISTS (SELECT 1 FROM venue_images WHERE image_id = v_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Image does not exist.';
    END IF;

    -- Xóa ảnh là an toàn, không cần check ràng buộc con vì nó là lá (leaf node)
    DELETE FROM venue_images WHERE image_id = v_id;
END$$

DELIMITER ;
