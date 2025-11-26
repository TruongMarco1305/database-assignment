-- rate
DELIMITER $$

-- Insert Rate
CREATE PROCEDURE Rate_Insert(
    IN p_clientId VARCHAR(36),
    IN p_locId VARCHAR(36),
    IN p_stars INT,
    IN p_comment TEXT
)
BEGIN
    INSERT INTO rates (client_id, location_id, stars, comment)
    VALUES (UUID_TO_BIN(p_clientId), UUID_TO_BIN(p_locId), p_stars, p_comment);
END$$

-- Update Rate
CREATE PROCEDURE Rate_Update(
    IN p_clientId VARCHAR(36),
    IN p_locId VARCHAR(36),
    IN p_stars INT,
    IN p_comment TEXT
)
BEGIN
    UPDATE rates 
    SET stars = p_stars, comment = p_comment
    WHERE client_id = UUID_TO_BIN(p_clientId) AND location_id = UUID_TO_BIN(p_locId);
END$$

-- Delete Rate
CREATE PROCEDURE Rate_Delete(
    IN p_clientId VARCHAR(36),
    IN p_locId VARCHAR(36)
)
BEGIN
    DELETE FROM rates 
    WHERE client_id = UUID_TO_BIN(p_clientId) AND location_id = UUID_TO_BIN(p_locId);
END$$

DELIMITER ;