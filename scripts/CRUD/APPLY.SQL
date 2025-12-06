-- apply
DELIMITER $$

-- 1. Insert Applies (Áp dụng mã giảm giá cho đơn hàng)
CREATE PROCEDURE Applies_Insert(
    IN p_orderId VARCHAR(36),
    IN p_discountId VARCHAR(36)
)
BEGIN
    DECLARE v_orderId BINARY(16);
    DECLARE v_discountId BINARY(16);
    
    SET v_orderId = UUID_TO_BIN(p_orderId);
    SET v_discountId = UUID_TO_BIN(p_discountId);

    -- 1. Validate Foreign Keys
    IF NOT EXISTS (SELECT 1 FROM orders WHERE order_id = v_orderId) THEN
        SIGNAL SQLSTATE '45077' SET MESSAGE_TEXT = 'Error: Order does not exist.';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM discounts WHERE discount_id = v_discountId) THEN
        SIGNAL SQLSTATE '45078' SET MESSAGE_TEXT = 'Error: Discount does not exist.';
    END IF;
    
    -- 2. Validate Duplicate (Đã có mã này chưa)
    IF EXISTS (SELECT 1 FROM applies WHERE order_id = v_orderId AND discount_id = v_discountId) THEN
        SIGNAL SQLSTATE '45079' SET MESSAGE_TEXT = 'Error: This discount is already applied to this order.';
    END IF;

    -- 3. Execute Insert
    -- (Trigger trg_Applies_ValidateDiscount sẽ chạy sau bước này để check điều kiện áp dụng: Hạn, Giá, Hạng...)
    INSERT INTO applies (order_id, discount_id)
    VALUES (v_orderId, v_discountId);
END$$

-- 3. Delete Applies (Gỡ bỏ mã giảm giá khỏi đơn hàng)
CREATE PROCEDURE Applies_Delete(
    IN p_orderId VARCHAR(36),
    IN p_discountId VARCHAR(36)
)
BEGIN
    DECLARE v_orderId BINARY(16);
    DECLARE v_discountId BINARY(16);
    
    SET v_orderId = UUID_TO_BIN(p_orderId);
    SET v_discountId = UUID_TO_BIN(p_discountId);

    -- 1. Validate Existence
    IF NOT EXISTS (SELECT 1 FROM applies WHERE order_id = v_orderId AND discount_id = v_discountId) THEN
        SIGNAL SQLSTATE '45082' SET MESSAGE_TEXT = 'Error: Discount not found in this order.';
    END IF;

    -- 2. Execute Delete
    DELETE FROM applies 
    WHERE order_id = v_orderId 
      AND discount_id = v_discountId;
END$$

DELIMITER ;