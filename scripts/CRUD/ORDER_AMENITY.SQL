DELIMITER $$
CREATE PROCEDURE OrderAmenity_Insert(
    IN p_orderId VARCHAR(36),
    IN p_amenityId VARCHAR(36)
)
BEGIN
    DECLARE v_amenityId BINARY(16);
    DECLARE v_orderId BINARY(16);
    DECLARE v_isActive BOOLEAN;
    
    SET v_amenityId = UUID_TO_BIN(p_amenityId);
    SET v_orderId = UUID_TO_BIN(p_orderId);

    -- 1. Validate Order Existence (Kiểm tra đơn hàng có tồn tại không)
    IF NOT EXISTS (SELECT 1 FROM orders WHERE order_id = v_orderId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order does not exist.';
    END IF;

    -- 2. Validate Amenity Availability
    -- Lấy trạng thái isActive của thiết bị
    SELECT isActive INTO v_isActive 
    FROM amenities WHERE amenity_id = v_amenityId;

    -- Nếu không tìm thấy (v_isActive vẫn là NULL) -> Báo lỗi không tồn tại
    IF v_isActive IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Amenity does not exist.';
    END IF;

    -- Nếu tìm thấy nhưng đang bận/hỏng (Active = 0) -> Báo lỗi
    IF v_isActive = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: This amenity is currently unavailable (In use or Broken).';
    END IF;

    -- 3. Insert
    -- Trigger (trg_OrderAmenity_Insert_UpdateOrder) sẽ tự động:
    --   + Cộng tiền vào Order
    --   + Khóa Amenity (isActive = 0)
    INSERT INTO order_amenities (order_id, amenity_id)
    VALUES (v_orderId, v_amenityId);
END$$

DELIMITER ;

-- no update

DELIMITER $$
CREATE PROCEDURE OrderAmenity_Delete(
    IN p_orderId VARCHAR(36),
    IN p_amenityId VARCHAR(36)
)
BEGIN
    DECLARE v_orderId BINARY(16);
    DECLARE v_amenityId BINARY(16);
    
    SET v_orderId = UUID_TO_BIN(p_orderId);
    SET v_amenityId = UUID_TO_BIN(p_amenityId);

    -- Kiểm tra tồn tại trước khi xóa (Optional, nhưng tốt cho UX)
    IF NOT EXISTS (SELECT 1 FROM order_amenities WHERE order_id = v_orderId AND amenity_id = v_amenityId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: This amenity is not attached to this order.';
    END IF;

    -- Execute Delete
    -- Trigger (trg_OrderAmenity_Delete_UpdateOrder) sẽ tự động:
    --   + Trừ tiền khỏi Order
    --   + Mở khóa Amenity (isActive = 1)
    DELETE FROM order_amenities 
    WHERE order_id = v_orderId 
      AND amenity_id = v_amenityId;
END$$

DELIMITER ;