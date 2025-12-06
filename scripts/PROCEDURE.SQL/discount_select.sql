DELIMITER $$
CREATE PROCEDURE GetDiscountInfo()
BEGIN
    SELECT 
        BIN_TO_UUID(discount_id)                 AS discount_id,
        name                                     AS name,
        percentage                               AS percentage,
        maxDiscountPrice                         AS maxDiscountPrice,
        minPrice                                 AS minPrice,
        BIN_TO_UUID(venueTypeId)                 AS venueTypeId,
        membershipTier                           AS membershipTier,
        startedAt                                AS startedAt,
        expiredAt                                AS expiredAt
    FROM 
        discounts;
    ORDER BY name ASC;
END$$
DELIMITER ;