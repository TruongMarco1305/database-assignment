-- amenity
DELIMITER $$

-- Insert Amenity
CREATE PROCEDURE Amenity_Insert(
    IN p_id VARCHAR(36),
    IN p_locId VARCHAR(36),
    IN p_category VARCHAR(50),
    IN p_desc TEXT
)
BEGIN
    INSERT INTO amenities (amenity_id, location_id, category, description)
    VALUES (UUID_TO_BIN(p_id), UUID_TO_BIN(p_locId), p_category, p_desc);
END$$

-- Update Amenity
CREATE PROCEDURE Amenity_Update(
    IN p_id VARCHAR(36),
    IN p_category VARCHAR(50),
    IN p_desc TEXT,
    IN p_isActive BOOLEAN
)
BEGIN
    UPDATE amenities 
    SET 
        category = COALESCE(p_category, category),
        description = COALESCE(p_desc, description),
        isActive = COALESCE(p_isActive, isActive)
    WHERE amenity_id = UUID_TO_BIN(p_id);
END$$

-- Delete Amenity
CREATE PROCEDURE Amenity_Delete(IN p_id VARCHAR(36))
BEGIN
    DELETE FROM amenities WHERE amenity_id = UUID_TO_BIN(p_id);
END$$

DELIMITER ;