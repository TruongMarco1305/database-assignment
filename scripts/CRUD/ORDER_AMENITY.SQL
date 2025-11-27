DELIMITER $$
CREATE PROCEDURE OrderAmenity_Insert(
    IN p_orderId VARCHAR(36),
    IN p_amenityId VARCHAR(36),
)
BEGIN
    DECLARE v_amenityId BINARY(16);
    DECLARE v_isActive BOOLEAN;
    
    SET v_amenityId = UUID_TO_BIN(p_amenityId);

    -- 1. Check Availability
    SELECT isActive INTO v_isActive 
    FROM amenities WHERE amenity_id = v_amenityId;

    IF v_isActive IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Amenity does not exist.';
    END IF;

    IF v_isActive = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: This amenity is currently unavailable.';
    END IF;

    -- 2. Insert
    -- (Trigger trg_OrderAmenity_Insert_Lock sẽ tự động set isActive = 0 sau lệnh này)
    INSERT INTO order_amenities (order_id, amenity_id)
    VALUES (UUID_TO_BIN(p_orderId), v_amenityId);
END$$

DELIMITER ;

-- no update

DELIMITER $$
CREATE PROCEDURE OrderAmenity_Delete(
    IN p_orderId VARCHAR(36),
    IN p_amenityId VARCHAR(36)
)
BEGIN
    -- Việc xóa này sẽ kích hoạt Trigger (xem phần 3 bên dưới) để set isActive = 1
    DELETE FROM order_amenities 
    WHERE order_id = UUID_TO_BIN(p_orderId) 
      AND amenity_id = UUID_TO_BIN(p_amenityId);
END$$

DELIMITER ;