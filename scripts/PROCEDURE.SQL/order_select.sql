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
