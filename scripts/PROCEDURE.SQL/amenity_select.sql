DELIMITER $$
CREATE PROCEDURE Filter_Amenities(
    IN p_locationId VARCHAR(36), -- Bắt buộc (phải biết đang xem kho của ai)
    IN p_category VARCHAR(50)   -- NULL được (lấy tất cả loại)
)
BEGIN
    SELECT 
        BIN_TO_UUID(amenity_id) AS amenity_id,
        category,
        description,
        price,
        createdAt
    FROM amenities
    WHERE location_id = UUID_TO_BIN(p_locationId)
      AND isActive = 1 -- Chỉ lấy đồ đang rảnh
      
      -- 1. Lọc theo Category (Nếu p_category NULL thì bỏ qua dòng này)
      AND (p_category IS NULL OR category = p_category)
      
    -- Sắp xếp: Ưu tiên gom theo loại trước, sau đó đến giá
    ORDER BY category ASC, price ASC;
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