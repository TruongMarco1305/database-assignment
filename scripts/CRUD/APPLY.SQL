-- apply
DELIMITER $$

-- 1. Insert Applies (Áp dụng mã giảm giá cho đơn hàng)
CREATE PROCEDURE Applies_Insert(
    IN p_orderId VARCHAR(36),
    IN p_discountId VARCHAR(36)
)
BEGIN
    -- Có thể thêm logic check trùng (nếu cần), nhưng Primary Key đã tự lo việc đó
    INSERT INTO applies (order_id, discount_id)
    VALUES (UUID_TO_BIN(p_orderId), UUID_TO_BIN(p_discountId));
END$$

-- 2. Update Applies (Đổi mã giảm giá này sang mã khác cho cùng 1 đơn)
-- Logic: Thay discount cũ bằng discount mới cho order đó
CREATE PROCEDURE Applies_Update(
    IN p_orderId VARCHAR(36),
    IN p_oldDiscountId VARCHAR(36), -- Mã cũ muốn thay
    IN p_newDiscountId VARCHAR(36)  -- Mã mới muốn áp dụng
)
BEGIN
    UPDATE applies 
    SET discount_id = UUID_TO_BIN(p_newDiscountId)
    WHERE order_id = UUID_TO_BIN(p_orderId) 
      AND discount_id = UUID_TO_BIN(p_oldDiscountId);
END$$

-- 3. Delete Applies (Gỡ bỏ mã giảm giá khỏi đơn hàng)
CREATE PROCEDURE Applies_Delete(
    IN p_orderId VARCHAR(36),
    IN p_discountId VARCHAR(36)
)
BEGIN
    DELETE FROM applies 
    WHERE order_id = UUID_TO_BIN(p_orderId) 
      AND discount_id = UUID_TO_BIN(p_discountId);
END$$

DELIMITER ;