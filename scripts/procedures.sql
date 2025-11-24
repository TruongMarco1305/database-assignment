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

CREATE PROCEDURE CreateLocation @Owner nvarchar(255), @Name nvarchar(150), @Description text, 
    @AddrNo nvarchar(20), @Ward nvarchar(50), @City nvarchar(50), @Policy text,
    @PhoneNo nvarchar(15), @MapURL nvarchar(255), @ThumbnailURL nvarchar(255)
AS
BEGIN
    INSERT INTO locations (location_id, owner_id, name, description, addrNo, ward, city, policy, phoneNo, mapURL, thumbnailURL)
    VALUES (uuid(), @Owner, @Name, @Description, @AddrNo, @Ward, @City, @Policy, @PhoneNo, @MapURL, @ThumbnailURL);
END
GO;

CREATE PROCEDURE UpdateLocation @LocationId nvarchar(255), @Name nvarchar(150) = NULL, @Description text = NULL, 
    @AddrNo nvarchar(20) = NULL, @Ward nvarchar(50) = NULL, @City nvarchar(50) = NULL, @Policy text = NULL,
    @PhoneNo nvarchar(15) = NULL, @MapURL nvarchar(255) = NULL, @ThumbnailURL nvarchar(255) = NULL
AS
BEGIN
    UPDATE locations
    SET 
        name = COALESCE(@Name, name),
        description = COALESCE(@Description, description),
        addrNo = COALESCE(@AddrNo, addrNo),
        ward = COALESCE(@Ward, ward),
        city = COALESCE(@City, city),
        policy = COALESCE(@Policy, policy),
        phoneNo = COALESCE(@PhoneNo, phoneNo),
        mapURL = COALESCE(@MapURL, mapURL),
        thumbnailURL = COALESCE(@ThumbnailURL, thumbnailURL)
    WHERE location_id = @LocationId;
END
GO;

CREATE PROCEDURE DeleteLocation @LocationId nvarchar(255)
AS
BEGIN
    DELETE FROM locations
    WHERE location_id = @LocationId;
END
GO;