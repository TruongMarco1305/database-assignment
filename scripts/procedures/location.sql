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

CREATE PROCEDURE GetOwnerInventory (
    IN p_owner_id BINARY(16)
)
BEGIN
    SELECT 
        -- Location Details
        BIN_TO_UUID(l.location_id) AS location_id,
        l.name AS location_name,
        l.addrNo, 
        l.ward, 
        l.city,
        l.avgRating,
        l.isActive AS isLocationActive,
        
        -- Venue Details
        BIN_TO_UUID(v.venueType_id) as venueType_id,
        v.name AS venue_name,
        v.floor,
        v.pricePerHour,
        v.isActive AS isVenueActive
        
    FROM locations l
    LEFT JOIN venues v ON l.location_id = v.location_id
    WHERE l.owner_id = p_owner_id
    ORDER BY l.createdAt DESC, v.name ASC;
END //

CREATE PROCEDURE GetOwnerOrders (
    IN p_owner_id BINARY(16),
    IN p_status VARCHAR(20),  -- Pass NULL to see ALL orders
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    
    -- Pagination Logic
    SET p_page = IF(p_page < 1, 1, p_page);
    SET p_limit = IF(p_limit < 1, 10, p_limit);
    SET v_offset = (p_page - 1) * p_limit;

    SELECT 
        BIN_TO_UUID(o.order_id) AS order_id,
        o.status,
        o.totalPrice,
        o.startHour,
        o.endHour,
        o.createdAt AS bookingDate,
        o.points,
        
        -- Venue Details
        v.name AS venue_name,
        v.floor,
        
        -- Location Details
        l.name AS location_name,
        l.city,
        l.addrNo,
        
        -- Client ID
        BIN_TO_UUID(o.client_id) AS client_id

    FROM orders o
    INNER JOIN venues v ON o.venue_loc_id = v.location_id AND o.venueName = v.name
    INNER JOIN locations l ON v.location_id = l.location_id
    
    WHERE l.owner_id = p_owner_id
    -- Standard Filter: If p_status is NULL, ignore this check. If not NULL, check equality.
    AND (p_status IS NULL OR o.status = p_status)
    
    ORDER BY o.createdAt DESC
    LIMIT p_limit OFFSET v_offset;
END //

DELIMITER ;
