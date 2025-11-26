-- favor
DELIMITER $$

-- Insert Favor (Like)
CREATE PROCEDURE Favor_Insert(
    IN p_clientId VARCHAR(36),
    IN p_locId VARCHAR(36)
)
BEGIN
    INSERT INTO favors (client_id, location_id)
    VALUES (UUID_TO_BIN(p_clientId), UUID_TO_BIN(p_locId));
END$$

-- Delete Favor (Unlike)
CREATE PROCEDURE Favor_Delete(
    IN p_clientId VARCHAR(36),
    IN p_locId VARCHAR(36)
)
BEGIN
    DELETE FROM favors 
    WHERE client_id = UUID_TO_BIN(p_clientId) AND location_id = UUID_TO_BIN(p_locId);
END$$

DELIMITER ;