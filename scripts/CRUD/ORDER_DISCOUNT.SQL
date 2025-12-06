BEGIN $$
CREATE PROCEDURE OrderDiscount_Insert(
    IN p_orderId VARCHAR(36),
    IN p_discountId VARCHAR(36)
)
BEGIN
    INSERT INTO OrderDiscount (orderId, discountId)
    VALUES (UUID_TO_BINARY(p_orderId), UUID_TO_BINARY(p_discountId));
END $$
DELIMITER;