-- discount
DELIMITER $$

-- Insert Discount
CREATE PROCEDURE Discount_Insert(
    IN p_id VARCHAR(36),
    IN p_name VARCHAR(100),
    IN p_percent INT,
    IN p_maxDisc DECIMAL(12,2), -- Bổ sung
    IN p_minPrice DECIMAL(12,2), -- Bổ sung
    IN p_venueTypeId VARCHAR(36),-- Bổ sung (ID loại phòng)
    IN p_tiers VARCHAR(255),     -- Bổ sung (VD: 'GOLD,PLATINUM')
    IN p_start DATETIME,
    IN p_end DATETIME
)
BEGIN
INSERT INTO discounts (
        discount_id, name, percentage, 
        maxDiscountPrice, minPrice, venueTypeId, membershipTier,
        startedAt, expiredAt
    )
    VALUES (
        UUID_TO_BIN(p_id), p_name, p_percent, 
        p_maxDisc, p_minPrice, v_venueTypeId, p_tiers, 
        p_start, p_end
    );
END$$

-- Update Discount
CREATE PROCEDURE Discount_Update(
    IN p_id VARCHAR(36),
    IN p_name VARCHAR(100),
    IN p_percent INT,
    IN p_maxDisc DECIMAL(12,2),  -- Bổ sung
    IN p_minPrice DECIMAL(12,2), -- Bổ sung
    IN p_venueTypeId VARCHAR(36),-- Bổ sung
    IN p_tiers VARCHAR(255),     -- Bổ sung
    IN p_start DATETIME,         -- Nên cho phép sửa ngày bắt đầu nếu chưa diễn ra
    IN p_end DATETIME
)
BEGIN
    UPDATE discounts 
    SET 
        name = p_name, 
        percentage = p_percent, 
        maxDiscountPrice = p_maxDisc,
        minPrice = p_minPrice,
        venueTypeId = v_venueTypeId,
        membershipTier = p_tiers,
        startedAt = p_start,
        expiredAt = p_end
    WHERE discount_id = UUID_TO_BIN(p_id);
END$$

-- Delete Discount
CREATE PROCEDURE Discount_Delete(IN p_id VARCHAR(36))
BEGIN
    DELETE FROM discounts WHERE discount_id = UUID_TO_BIN(p_id);
END$$

DELIMITER ;