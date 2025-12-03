DELIMITER //
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
