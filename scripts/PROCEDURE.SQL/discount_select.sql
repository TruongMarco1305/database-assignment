DELIMITER $$
CREATE PROCEDURE GetDiscountInfo()
BEGIN
    SELECT 
        BIN_TO_UUID(discount_id)                 AS discount_id,
        name                                     AS name,
        percentage                               AS percentage,
        maxDiscountPrice                         AS max_discount_price,
        minPrice                                 AS min_price,
        BIN_TO_UUID(venueTypeId)                 AS venue_type_id,
        membershipTier                           AS membership_tier,
        startedAt                                AS started_at,
        expiredAt                                AS expired_at
    FROM 
        discounts;
    ORDER BY name ASC;
END$$
DELIMITER ;