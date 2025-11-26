-- owner
DELIMITER $$

-- Insert Owner
CREATE PROCEDURE Owner_Insert(
    IN p_userId VARCHAR(36),
    IN p_bankId VARCHAR(50),
    IN p_bankName VARCHAR(100),
    IN p_accName VARCHAR(50),
    IN p_accNo VARCHAR(50)
)
BEGIN
    -- 1. Check Required Fields
    IF p_bankId IS NULL OR p_bankName IS NULL OR p_accName IS NULL OR p_accNo IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: All bank details are required.';
    END IF;

    -- 2. Check if User exists in USERS table (Foreign Key integrity)
    IF NOT EXISTS (SELECT 1 FROM users WHERE id = v_uuid) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: User ID does not exist in Users table.';
    END IF;

    -- 3. Check if this User is already an Owner (One-to-One relationship)
    IF EXISTS (SELECT 1 FROM owners WHERE user_id = v_uuid) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: This User is already registered as an Owner.';
    END IF;
    
    INSERT INTO owners (user_id, bankId, bankName, accountName, accountNo)
    VALUES (v_uuid, p_bankId, p_bankName, p_accName, p_accNo);
END$$

-- Update Owner
CREATE PROCEDURE Owner_Update(
    IN p_userId VARCHAR(36),
    IN p_bankId VARCHAR(50),
    IN p_bankName VARCHAR(100),
    IN p_accName VARCHAR(50),
    IN p_accNo VARCHAR(50)
)
BEGIN
    DECLARE v_uuid BINARY(16);
    SET v_uuid = UUID_TO_BIN(p_userId);

    -- 1. Check Existence
    IF NOT EXISTS (SELECT 1 FROM owners WHERE user_id = v_uuid) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Owner does not exist.';
    END IF;

    -- Execute Update with Partial Update logic
    UPDATE owners 
    SET 
        bankId = COALESCE(p_bankId, bankId),
        bankName = COALESCE(p_bankName, bankName),
        accountName = COALESCE(p_accName, accountName),
        accountNo = COALESCE(p_accNo, accountNo)
    WHERE user_id = v_uuid;
END$$

-- Delete Owner
CREATE PROCEDURE Owner_Delete(IN p_userId VARCHAR(36))
BEGIN
    DECLARE v_uuid BINARY(16);
    SET v_uuid = UUID_TO_BIN(p_userId);

    -- 1. Check Existence
    IF NOT EXISTS (SELECT 1 FROM owners WHERE user_id = v_uuid) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Owner does not exist.';
    END IF;

    -- 2. Constraint Check: LOCATIONS
    -- Reason: Cannot delete an owner who manages active locations. 
    -- Deleting the owner would cascade delete all locations (due to FK settings), potentially destroying critical business data.
    IF EXISTS (SELECT 1 FROM locations WHERE owner_id = v_uuid) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Cannot delete Owner. This Owner has registered Locations. Please delete or reassign locations first.';
    END IF;

    -- Execute Delete
    DELETE FROM owners WHERE user_id = v_uuid;
END$$

DELIMITER ;
