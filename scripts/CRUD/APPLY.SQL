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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order does not exist.';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM discounts WHERE discount_id = v_discountId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Discount does not exist.';
    END IF;
    
    -- 2. Validate Duplicate (Đã có mã này chưa)
    IF EXISTS (SELECT 1 FROM applies WHERE order_id = v_orderId AND discount_id = v_discountId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: This discount is already applied to this order.';
    END IF;

    -- 3. Execute Insert
    -- (Trigger trg_Applies_ValidateDiscount sẽ chạy sau bước này để check điều kiện áp dụng: Hạn, Giá, Hạng...)
    INSERT INTO applies (order_id, discount_id)
    VALUES (v_orderId, v_discountId);
END$$

-- 2. Update Applies (Đổi mã giảm giá này sang mã khác cho cùng 1 đơn)
-- Logic: Thay discount cũ bằng discount mới cho order đó
CREATE PROCEDURE Applies_Update(
    IN p_orderId VARCHAR(36),
    IN p_oldDiscountId VARCHAR(36), -- Mã cũ muốn thay
    IN p_newDiscountId VARCHAR(36)  -- Mã mới muốn áp dụng
)
BEGIN
    DECLARE v_orderId BINARY(16);
    DECLARE v_oldDiscountId BINARY(16);
    DECLARE v_newDiscountId BINARY(16);
    
    SET v_orderId = UUID_TO_BIN(p_orderId);
    SET v_oldDiscountId = UUID_TO_BIN(p_oldDiscountId);
    SET v_newDiscountId = UUID_TO_BIN(p_newDiscountId);

    -- 1. Validate New Discount Existence
    IF NOT EXISTS (SELECT 1 FROM discounts WHERE discount_id = v_newDiscountId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: New Discount does not exist.';
    END IF;

    -- 2. Validate Existing Application (Có dòng cũ để sửa không?)
    IF NOT EXISTS (SELECT 1 FROM applies WHERE order_id = v_orderId AND discount_id = v_oldDiscountId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: The old discount was not applied to this order.';
    END IF;

    -- 3. Execute Update
    UPDATE applies 
    SET discount_id = v_newDiscountId
    WHERE order_id = v_orderId 
      AND discount_id = v_oldDiscountId;
      
    -- LƯU Ý: Cần có Trigger BEFORE UPDATE trên bảng APPLIES (tương tự Insert) 
    -- để kiểm tra xem Mã Mới có hợp lệ với đơn hàng không.
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Discount not found in this order.';
    END IF;

    -- 2. Execute Delete
    DELETE FROM applies 
    WHERE order_id = v_orderId 
      AND discount_id = v_discountId;
END$$

DELIMITER ;