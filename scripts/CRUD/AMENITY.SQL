-- amenity
DELIMITER $$

-- Insert Amenity
CREATE PROCEDURE Amenity_Insert(
    IN p_id VARCHAR(36),
    IN p_locId VARCHAR(36),
    IN p_category VARCHAR(50), -- Projector, Catering, Audio Set
    IN p_desc TEXT,
    IN p_price DECIMAL(12,2)
)
BEGIN
    DECLARE v_locId BINARY(16);
    SET v_locId = UUID_TO_BIN(p_locId);

    -- 1. Validate Location Existence (Foreign Key)
    IF NOT EXISTS (SELECT 1 FROM locations WHERE location_id = v_locId) THEN
        SIGNAL SQLSTATE '45083' SET MESSAGE_TEXT = 'Error: Location does not exist.';
    END IF;

    -- 2. Validate Price
    IF p_price < 0 THEN
        SIGNAL SQLSTATE '45084' SET MESSAGE_TEXT = 'Error: Price cannot be negative.';
    END IF;

    INSERT INTO amenities (amenity_id, location_id, category, description, price)
    VALUES (UUID_TO_BIN(p_id), v_locId, p_category, p_desc, p_price);
END$$

-- Update Amenity
CREATE PROCEDURE Amenity_Update(
    IN p_id VARCHAR(36),
    IN p_category VARCHAR(50),
    IN p_desc TEXT,
    IN p_price DECIMAL(12,2),
    IN p_isActive BOOLEAN
)
BEGIN
    DECLARE v_id BINARY(16);
    SET v_id = UUID_TO_BIN(p_id);

    -- 1. Check Existence
    IF NOT EXISTS (SELECT 1 FROM amenities WHERE amenity_id = v_id) THEN
        SIGNAL SQLSTATE '45085' SET MESSAGE_TEXT = 'Error: Amenity does not exist.';
    END IF;

    -- 2. Validate Price
    IF p_price IS NOT NULL AND p_price < 0 THEN
        SIGNAL SQLSTATE '45086' SET MESSAGE_TEXT = 'Error: Price cannot be negative.';
    END IF;

    UPDATE amenities 
    SET 
        category       = COALESCE(p_category, category),
        description    = COALESCE(p_desc, description),
        price          = COALESCE(p_price, price),
        isActive       = COALESCE(p_isActive, isActive)
    WHERE amenity_id = v_id;
END$$

-- Delete Amenity
CREATE PROCEDURE Amenity_Delete(IN p_id VARCHAR(36))
BEGIN
    DECLARE v_id BINARY(16);
    SET v_id = UUID_TO_BIN(p_id);

    -- 1. Check Existence
    IF NOT EXISTS (SELECT 1 FROM amenities WHERE amenity_id = v_id) THEN
        SIGNAL SQLSTATE '45087' SET MESSAGE_TEXT = 'Error: Amenity does not exist.';
    END IF;

    -- 2. Constraint Check: ORDER HISTORY
    -- Không được xóa thiết bị đã từng được thuê (để bảo toàn lịch sử đơn hàng cũ)
    IF EXISTS (SELECT 1 FROM order_amenities WHERE amenity_id = v_id) THEN
        SIGNAL SQLSTATE '45088' 
        SET MESSAGE_TEXT = 'Error: Cannot delete amenity because it is linked to existing orders. Please deactivate it instead.';
    END IF;

    DELETE FROM amenities WHERE amenity_id = v_id;
END$$

DELIMITER ;