-- amenity
DELIMITER $$

-- Insert Amenity
CREATE PROCEDURE Amenity_Insert(
    IN p_id VARCHAR(36),
    IN p_locId VARCHAR(36),
    IN p_category VARCHAR(50),
    IN p_desc TEXT,
    IN p_price DECIMAL(12,2)
)
BEGIN
    INSERT INTO amenities (amenity_id, location_id, category, description, price)
    VALUES (UUID_TO_BIN(p_id), UUID_TO_BIN(p_locId), p_category, p_desc, p_price);
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
    -- Validate Price (Nếu có truyền vào thì mới check)
    IF p_price IS NOT NULL AND p_price < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Price cannot be negative.';
    END IF;

    UPDATE amenities 
    SET 
        category = COALESCE(p_category, category),
        description = COALESCE(p_desc, description),
        price       = COALESCE(p_price, price), -- Cập nhật giá
        isActive = COALESCE(p_isActive, isActive)
    WHERE amenity_id = UUID_TO_BIN(p_id);
END$$

-- Delete Amenity
CREATE PROCEDURE Amenity_Delete(IN p_id VARCHAR(36))
BEGIN
    DECLARE v_id BINARY(16);
    SET v_id = UUID_TO_BIN(p_id);

    -- 1. Check Existence
    IF NOT EXISTS (SELECT 1 FROM amenities WHERE amenity_id = v_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Amenity does not exist.';
    END IF;

    -- 2. Constraint Check: Không xóa nếu đã có trong lịch sử đơn hàng
    -- (Dù active hay inactive, nếu đã từng nằm trong order thì không được xóa để bảo toàn lịch sử)
    IF EXISTS (SELECT 1 FROM order_amenities WHERE amenity_id = v_id) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Cannot delete amenity because it is linked to existing orders. Please set isActive=0 instead.';
    END IF;

    DELETE FROM amenities WHERE amenity_id = v_id;
END$$

DELIMITER ;