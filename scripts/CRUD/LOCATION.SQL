-- location
DELIMITER $$

-- Insert Location
CREATE PROCEDURE Location_Insert(
    IN p_id VARCHAR(36), -- Generate UUID ở code rồi truyền vào
    IN p_ownerId VARCHAR(36),
    IN p_name VARCHAR(150),
    IN p_desc TEXT,
    IN p_addrNo VARCHAR(20),
    IN p_ward VARCHAR(50),
    IN p_city VARCHAR(50),
    IN p_phoneNo VARCHAR(15),      
    IN p_policy TEXT,               
    IN p_mapURL VARCHAR(255),
    IN p_thumbURL VARCHAR(255)
)
BEGIN
    INSERT INTO locations (location_id, owner_id, name, description, addrNo, ward, city, phoneNo, policy, mapURL, thumbnailURL)
    VALUES (UUID_TO_BIN(p_id), UUID_TO_BIN(p_ownerId), p_name, p_desc, p_addrNo, p_ward, p_city, p_phoneNo, p_policy, p_mapURL, p_thumbURL);
END$$

-- Update Location
CREATE PROCEDURE Location_Update(
    IN p_id VARCHAR(36),
    IN p_name VARCHAR(150),
    IN p_desc TEXT,
    IN p_addrNo VARCHAR(20),
    IN p_ward VARCHAR(50),           -- Bổ sung cho đầy đủ
    IN p_city VARCHAR(50),           -- Bổ sung cho đầy đủ
    IN p_phoneNo VARCHAR(15),        -- Đã bổ sung
    IN p_policy TEXT,                -- Đã bổ sung
    IN p_mapURL VARCHAR(255),
    IN p_thumbURL VARCHAR(255),      -- Bổ sung (thường sẽ cần sửa ảnh)
    IN p_isActive BOOLEAN
)
BEGIN
    UPDATE locations 
    SET name = p_name, description = p_desc, addrNo = p_addrNo, ward = p_ward, city = p_city, phoneNo = p_phoneNo, policy = p_policy, mapURL = p_mapURL, thumbnailURL = p_thumbURL, isActive = p_isActive
    WHERE location_id = UUID_TO_BIN(p_id);
END$$

-- Delete Location
CREATE PROCEDURE Location_Delete(IN p_id VARCHAR(36))
BEGIN
    DELETE FROM locations WHERE location_id = UUID_TO_BIN(p_id);
END$$

DELIMITER ;