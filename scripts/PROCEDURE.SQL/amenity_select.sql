DELIMITER $$

DROP PROCEDURE IF EXISTS sp_GetAvailableAmenities_ByCategory$$

CREATE PROCEDURE sp_GetAvailableAmenities_ByCategory(
    IN p_locationId VARCHAR(36),
    IN p_category VARCHAR(50)
)
BEGIN
    SELECT 
        BIN_TO_UUID(amenity_id) AS amenity_id,
        category,
        description, -- Mô tả chi tiết (VD: 'Ghế Tiffany Gold')
        price,       -- Giá thuê
        createdAt
    FROM amenities
    WHERE location_id = UUID_TO_BIN(p_locationId)
      AND category = p_category
      AND isActive = 1 -- Chỉ lấy đồ đang rảnh (trong kho)
    ORDER BY price ASC; -- Sắp xếp theo giá hoặc ngày tạo
END$$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS func_CountAvailableAmenities$$

CREATE FUNCTION func_CountAvailableAmenities(
    p_locationId VARCHAR(36),
    p_category VARCHAR(50)
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*) INTO v_count
    FROM amenities
    WHERE location_id = UUID_TO_BIN(p_locationId)
      AND category = p_category
      AND isActive = 1; -- Chỉ đếm hàng rảnh

    RETURN v_count;
END$$

DELIMITER ;