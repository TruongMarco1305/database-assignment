DELIMITER //

/* ----------------------------------------------------------
   Procedure: CreateVenueType`
   ---------------------------------------------------------- */
CREATE PROCEDURE CreateVenueType(
    IN p_Name VARCHAR(100),
    IN p_Description TEXT,
    IN p_PricePerHour DECIMAL(10, 2),
    IN p_Capacity INT,
    IN p_Area DECIMAL(10, 1)
)
BEGIN
    INSERT INTO venue_types (
        name, description, pricePerHour, capacity, area
    )
    VALUES (
        UUID(), p_Name, p_Description, p_PricePerHour, p_Capacity, p_Area
    );
END //

/* ----------------------------------------------------------
   Procedure: UpdateVenueType
   ---------------------------------------------------------- */
CREATE PROCEDURE UpdateVenueType(
    IN p_VenueTypeId VARCHAR(255),
    IN p_Name VARCHAR(100),
    IN p_Description TEXT,
    IN p_PricePerHour DECIMAL(10, 2),
    IN p_Capacity INT,
    IN p_Area DECIMAL(10, 1)
)
BEGIN
    UPDATE venue_types
    SET 
        name        = COALESCE(p_Name, name),
        description = COALESCE(p_Description, description),
        pricePerHour= COALESCE(p_PricePerHour, pricePerHour),
        capacity    = COALESCE(p_Capacity, capacity),
        area        = COALESCE(p_Area, area),
    WHERE venue_type_id = p_VenueTypeId;
END //

/* ----------------------------------------------------------
   Procedure: DeleteVenueType
   ---------------------------------------------------------- */
CREATE PROCEDURE DeleteVenueType(
    IN p_VenueTypeId VARCHAR(255)
)
BEGIN
    DELETE FROM venue_types
    WHERE venue_type_id = p_VenueTypeId;
END //

DELIMITER ;