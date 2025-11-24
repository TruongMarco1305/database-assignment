DELIMITER //

/* ----------------------------------------------------------
   Procedure: CreateVenue`
   ---------------------------------------------------------- */
CREATE PROCEDURE CreateVenue(
    IN p_LocationId VARCHAR(255),
    IN p_Name VARCHAR(100),
    IN p_VenueTypeId VARCHAR(255),
    IN p_Floor VARCHAR(10)
)
BEGIN
    INSERT INTO venues (
        location_id, venue_type_id, name, floor
    )
    VALUES (
        p_LocationId, p_VenueTypeId, p_Name, p_Floor
    );
END //

/* ----------------------------------------------------------
   Procedure: UpdateVenue
   ---------------------------------------------------------- */
CREATE PROCEDURE UpdateVenue(
    IN p_LocationId VARCHAR(255),
    IN p_Name VARCHAR(100),
    IN p_VenueTypeId VARCHAR(255),
    IN p_Floor VARCHAR(10)
)
BEGIN
    UPDATE venues
    SET 
        location_id = COALESCE(p_LocationId, location_id),
        name        = COALESCE(p_Name, name),
        venue_type_id = COALESCE(p_VenueTypeId, venue_type_id),
        floor       = COALESCE(p_Floor, floor)
    WHERE location_id = p_LocationId AND name = p_Name;
END //

/* ----------------------------------------------------------
   Procedure: DeleteVenue
   ---------------------------------------------------------- */
CREATE PROCEDURE DeleteVenue(
    IN p_LocationId VARCHAR(255),
    IN p_Name VARCHAR(100)
)
BEGIN
    DELETE FROM venues
    WHERE location_id = p_LocationId AND name = p_Name;
END //

DELIMITER ;