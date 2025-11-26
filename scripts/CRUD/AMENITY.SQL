-- amenity
DELIMITER $$

-- Insert Amenity
CREATE PROCEDURE Amenity_Insert(
    IN p_id VARCHAR(36),
    IN p_locId VARCHAR(36),
    IN p_venueName VARCHAR(100),
    IN p_category VARCHAR(50),
    IN p_desc TEXT
)
BEGIN
    INSERT INTO amenities (amenity_id, location_id, venueName, category, description)
    VALUES (UUID_TO_BIN(p_id), UUID_TO_BIN(p_locId), p_venueName, p_category, p_desc);
END$$

-- Update Amenity
CREATE PROCEDURE Amenity_Update(
    IN p_id VARCHAR(36),
    IN p_venueName VARCHAR(100),
    IN p_desc TEXT,
    IN p_isActive BOOLEAN
)
BEGIN
    UPDATE amenities 
    SET venueName = p_venueName, description = p_desc, isActive = p_isActive
    WHERE amenity_id = UUID_TO_BIN(p_id);
END$$

-- Delete Amenity
CREATE PROCEDURE Amenity_Delete(IN p_id VARCHAR(36))
BEGIN
    DELETE FROM amenities WHERE amenity_id = UUID_TO_BIN(p_id);
END$$

DELIMITER ;