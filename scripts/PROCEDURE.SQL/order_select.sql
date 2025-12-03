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

DELIMITER $$
CREATE PROCEDURE getIncomingOrdersForOwner(
    IN p_ownerId BINARY(16)
)
BEGIN
  SELECT
    BIN_TO_UUID(o.order_id) AS order_id,
    o.status AS order_status,
    o.startTime,
    o.endTime,
    o.totalPrice,
    BIN_TO_UUID(c.user_id) AS client_id,
    c.firstName AS client_first_name,
    c.lastName AS client_last_name,
    c.email AS client_email,
    c.phoneNo AS client_phone
  FROM orders o
  JOIN clients c ON o.client_id = c.user_id
  JOIN venues v ON o.venue_id = v.venue_id
  WHERE v.owner_id = p_ownerId
    AND o.status IN ('PENDING', 'CONFIRMED')  -- Only incoming orders
  ORDER BY o.startTime DESC;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE getCompletedOrdersForOwner(
    IN p_ownerId BINARY(16)
)
BEGIN
  SELECT
    BIN_TO_UUID(o.order_id) AS order_id,
    o.status AS order_status,
    o.startTime,
    o.endTime,
    o.totalPrice,
    BIN_TO_UUID(c.user_id) AS client_id,
    c.firstName AS client_first_name,
    c.lastName AS client_last_name,
    c.email AS client_email,
    c.phoneNo AS client_phone
  FROM orders o
  JOIN clients c ON o.client_id = c.user_id
  JOIN venues v ON o.venue_id = v.venue_id
  WHERE v.owner_id = p_ownerId
    AND o.status = 'COMPLETED'  -- Only incoming orders
  ORDER BY o.startTime DESC;
END$$
DELIMITER ;
