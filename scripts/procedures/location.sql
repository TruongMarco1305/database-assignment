DELIMITER //

/* ----------------------------------------------------------
   Procedure: CreateLocation
   ---------------------------------------------------------- */
CREATE PROCEDURE CreateLocation(
    IN p_Owner VARCHAR(255),
    IN p_Name VARCHAR(150),
    IN p_Description TEXT,
    IN p_AddrNo VARCHAR(20),
    IN p_Ward VARCHAR(50),
    IN p_City VARCHAR(50),
    IN p_Policy TEXT,
    IN p_PhoneNo VARCHAR(15),
    IN p_MapURL VARCHAR(255),
    IN p_ThumbnailURL VARCHAR(255)
)
BEGIN
    INSERT INTO locations (
        location_id, owner_id, name, description, addrNo, ward, 
        city, policy, phoneNo, mapURL, thumbnailURL
    )
    VALUES (
        UUID(), p_Owner, p_Name, p_Description, p_AddrNo, p_Ward, 
        p_City, p_Policy, p_PhoneNo, p_MapURL, p_ThumbnailURL
    );
END //

/* ----------------------------------------------------------
   Procedure: UpdateLocation
   ---------------------------------------------------------- */
CREATE PROCEDURE UpdateLocation(
    IN p_LocationId VARCHAR(255),
    IN p_Name VARCHAR(150),
    IN p_Description TEXT,
    IN p_AddrNo VARCHAR(20),
    IN p_Ward VARCHAR(50),
    IN p_City VARCHAR(50),
    IN p_Policy TEXT,
    IN p_PhoneNo VARCHAR(15),
    IN p_MapURL VARCHAR(255),
    IN p_ThumbnailURL VARCHAR(255)
)
BEGIN
    UPDATE locations
    SET 
        name        = COALESCE(p_Name, name),
        description = COALESCE(p_Description, description),
        addrNo      = COALESCE(p_AddrNo, addrNo),
        ward        = COALESCE(p_Ward, ward),
        city        = COALESCE(p_City, city),
        policy      = COALESCE(p_Policy, policy),
        phoneNo     = COALESCE(p_PhoneNo, phoneNo),
        mapURL      = COALESCE(p_MapURL, mapURL),
        thumbnailURL= COALESCE(p_ThumbnailURL, thumbnailURL)
    WHERE location_id = p_LocationId;
END //

/* ----------------------------------------------------------
   Procedure: DeleteLocation
   ---------------------------------------------------------- */
CREATE PROCEDURE DeleteLocation(
    IN p_LocationId VARCHAR(255)
)
BEGIN
    DELETE FROM locations
    WHERE location_id = p_LocationId;
END //

DELIMITER ;