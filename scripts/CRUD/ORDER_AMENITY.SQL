DELIMITER $$
CREATE PROCEDURE OrderAmenity_Insert(
    IN p_orderId VARCHAR(36),
    IN p_amenityName VARCHAR(100) -- Chỉ cần tên, location tự lấy từ Order
)
BEGIN
    DECLARE v_amenityId BINARY(16);
    DECLARE v_orderId BINARY(16);
    DECLARE v_isActive BOOLEAN;
    
    SET v_orderId = UUID_TO_BIN(p_orderId);

    -- 1. Lấy Location ID từ Order (Để đảm bảo Amenity thuộc đúng địa điểm)
    SELECT venue_loc_id INTO v_locId
    FROM orders WHERE order_id = v_orderId;

    IF v_locId IS NULL THEN
        SIGNAL SQLSTATE '45051' SET MESSAGE_TEXT = 'Error: Order does not exist.';
    END IF;

    -- 2. Validate Amenity (Check theo Location + Name)
    SELECT isActive INTO v_isActive 
    FROM amenities 
    WHERE location_id = v_locId AND amenity_name = p_amenityName;

    IF v_isActive IS NULL THEN
        SIGNAL SQLSTATE '45052' SET MESSAGE_TEXT = 'Error: Amenity does not exist in this location.';
    END IF;

    -- Nếu tìm thấy nhưng đang bận/hỏng (Active = 0) -> Báo lỗi
    IF v_isActive = 0 THEN
        SIGNAL SQLSTATE '45053' SET MESSAGE_TEXT = 'Error: This amenity is currently unavailable (Inactive).';
    END IF;

    -- 3. Insert
    -- Trigger (trg_OrderAmenity_Insert_UpdateOrder) sẽ tự động:
    --   + Cộng tiền vào Order
    --   + Khóa Amenity (isActive = 0)
    INSERT INTO order_amenities (order_id, location_id, amenity_name)
    VALUES (v_orderId, v_locId, p_amenityName);
END$$

DELIMITER ;

-- no update

DELIMITER $$
CREATE PROCEDURE OrderAmenity_Delete(
    IN p_orderId VARCHAR(36),
    IN p_amenityName VARCHAR(100) -- Thay đổi: Dùng Tên thay vì ID
)
BEGIN
    DECLARE v_orderId BINARY(16);
    
    SET v_orderId = UUID_TO_BIN(p_orderId);

    -- Kiểm tra tồn tại trước khi xóa
    -- (Lưu ý: Trong bảng order_amenities, cặp order_id + amenity_name là duy nhất)
    IF NOT EXISTS (
        SELECT 1 FROM order_amenities 
        WHERE order_id = v_orderId AND amenity_name = p_amenityName
    ) THEN
        SIGNAL SQLSTATE '45054' SET MESSAGE_TEXT = 'Error: This amenity is not attached to this order.';
    END IF;

    -- Execute Delete
    -- Trigger (trg_OrderAmenity_Delete_UpdateOrder) vẫn sẽ tự động chạy để trừ tiền
    DELETE FROM order_amenities 
    WHERE order_id = v_orderId 
      AND amenity_name = p_amenityName;
END$$

DELIMITER ;