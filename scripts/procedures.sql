CREATE DEFINER=`stackops`@`%` PROCEDURE `booking`.`getListLocations`(
    IN p_city VARCHAR(50),
    IN p_minCapacity INT,
    IN p_startTime DATETIME,
    IN p_endTime DATETIME,
    IN p_minPrice DECIMAL(10, 2),
    IN p_maxPrice DECIMAL(10, 2),
    IN p_minArea INT,
    IN p_minAvgRating DECIMAL(2, 1),
    -- IN p_clientId VARCHAR(255),
    -- IN p_onlyFavorites BOOLEAN,
    IN p_sort VARCHAR(4)
)
BEGIN
SELECT
    location.location_id,
    location.name AS locationName,
    location.description AS locationDescription,
    location.addrNo,
    location.ward,
    location.city,
    location.avgRating,
    location.policy,
    location.phoneNo AS locationPhone,
    venue.name AS venueName,
    venue.floor,
    venue.isActive AS venueIsActive,
    venueType.venueType_id,
    venueType.name AS venueTypeName,
    venueType.description AS venueTypeDescription,
    venueType.pricePerHour,
    venueType.capacity,
    venueType.area
    -- CASE
    --     WHEN favourite.client_id IS NULL THEN 0
    --     ELSE 1
    -- END AS isFavoriteForUser
FROM
    locations location
    JOIN venues venue ON venue.location_id = location.location_id
    JOIN venue_types venueType ON venueType.venueType_id = venue.venueType_id
    -- LEFT JOIN FAVORS favourite ON favourite.location_id = location.location_id
    -- AND favourite.client_id = p_clientId
WHERE
    location.city = p_city
    AND location.isActive = 1
    AND venue.isActive = 1
    AND (
        p_minCapacity IS NULL
        OR venueType.capacity >= p_minCapacity
    )
    AND (
        p_minArea IS NULL
        OR venueType.area >= p_minArea
    )
    AND (
        p_minAvgRating IS NULL
        OR location.avgRating >= p_minAvgRating
    )
    AND (
        p_minPrice IS NULL
        OR venueType.pricePerHour >= p_minPrice
    )
    AND (
        p_maxPrice IS NULL
        OR venueType.pricePerHour <= p_maxPrice
    )
    -- AND (
    --     p_clientId IS NULL
    --     OR p_onlyFavorites = 0
    --     OR favourite.client_id IS NOT NULL
    -- )
    AND (
        p_startTime IS NULL
        OR p_endTime IS NULL
        -- OR NOT EXISTS (
        --     SELECT
        --         1
        --     FROM
        --         ORDERS o
        --     WHERE
        --         o.venue_loc_id = venue.location_id
        --         AND o.venueName = venue.name
        --         AND (
        --             (
        --                 o.status = 'Pending'
        --                 AND o.expiredAt > CURRENT_TIMESTAMP
        --             )
        --             OR o.status = 'Confirmed'
        --         )
        --         AND o.startHour < p_endTime
        --         AND o.endHour > p_startTime
        -- )
    )
    -- Sort by price (tăng dần)
ORDER BY
    CASE
        WHEN p_sort = 'ASC' THEN venueType.pricePerHour
    END ASC,
    CASE
        WHEN p_sort = 'DESC' THEN venueType.pricePerHour
    END DESC;

END

DELIMITER //

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

DELIMITER ;

-- CALL CreateLocation('u_owner_01', 'My Shop', 'A great place', '123', 'Ward 1', 'HCMC', 'No smoking', '555-0199', 'http://map', 'http://thumb');

DELIMITER //

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

DELIMITER ;
-- CALL UpdateLocation('bf0e4b98-c90f-11f0-90ae-8afd6457d52f', 'My storage', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

DELIMITER //

CREATE PROCEDURE DeleteLocation(
    IN p_LocationId VARCHAR(255)
)
BEGIN
    DELETE FROM locations
    WHERE location_id = p_LocationId;
END //

DELIMITER ;
