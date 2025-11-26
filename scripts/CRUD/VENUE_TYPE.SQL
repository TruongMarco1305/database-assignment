-- venue_type
DELIMITER $$

-- Insert Type
CREATE PROCEDURE VenueType_Insert(
    IN p_id VARCHAR(36),
    IN p_name VARCHAR(50),
    IN p_desc TEXT,
    IN p_minCap INT,
    IN p_maxCap INT,
    IN p_area DECIMAL(10,1)
)
BEGIN
    INSERT INTO venue_types (venueType_id, name, description, minCapacity, maxCapacity, area)
    VALUES (UUID_TO_BIN(p_id), p_name, p_desc, p_minCap, p_maxCap, p_area);
END$$

-- Update Type
CREATE PROCEDURE VenueType_Update(
    IN p_id VARCHAR(36),
    IN p_name VARCHAR(50),
    IN p_desc TEXT,          -- <--- Bổ sung tham số này
    IN p_minCap INT,
    IN p_maxCap INT,
    IN p_area DECIMAL(10,1)
)
BEGIN
    UPDATE venue_types 
    SET name = p_name, description = p_desc, minCapacity = p_minCap, maxCapacity = p_maxCap, area = p_area
    WHERE venueType_id = UUID_TO_BIN(p_id);
END$$

-- Delete Type
CREATE PROCEDURE VenueType_Delete(IN p_id VARCHAR(36))
BEGIN
    DELETE FROM venue_types WHERE venueType_id = UUID_TO_BIN(p_id);
END$$

DELIMITER ;