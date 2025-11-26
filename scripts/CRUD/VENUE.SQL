-- venue
DELIMITER $$

-- Insert Venue
CREATE PROCEDURE Venue_Insert(
    IN p_locId VARCHAR(36),
    IN p_name VARCHAR(100),
    IN p_typeId VARCHAR(36),
    IN p_floor VARCHAR(10),
    IN p_price DECIMAL(10,2)
)
BEGIN
    INSERT INTO venues (location_id, name, venueType_id, floor, pricePerHour)
    VALUES (UUID_TO_BIN(p_locId), p_name, UUID_TO_BIN(p_typeId), p_floor, p_price);
END$$

-- Update Venue
CREATE PROCEDURE Venue_Update(
    IN p_locId VARCHAR(36),
    IN p_name VARCHAR(100),
    IN p_typeId VARCHAR(36), -- <--- Bổ sung tham số này
    IN p_floor VARCHAR(10),
    IN p_price DECIMAL(10,2),
    IN p_isActive BOOLEAN
)
BEGIN
    UPDATE venues 
    SET venueType_id = UUID_TO_BIN(p_typeId), floor = p_floor, pricePerHour = p_price, isActive = p_isActive
    WHERE location_id = UUID_TO_BIN(p_locId) AND name = p_name;
END$$

-- Delete Venue
CREATE PROCEDURE Venue_Delete(
    IN p_locId VARCHAR(36),
    IN p_name VARCHAR(100)
)
BEGIN
    DELETE FROM venues WHERE location_id = UUID_TO_BIN(p_locId) AND name = p_name;
END$$

DELIMITER ;