-- user
DELIMITER $$

-- Insert User
CREATE PROCEDURE User_Insert(
    IN p_id VARCHAR(36), -- ID được truyền từ Backend hoặc tạo mới
    IN p_email VARCHAR(100),
    IN p_password VARCHAR(255),
    IN p_firstName VARCHAR(50),
    IN p_lastName VARCHAR(50),
    IN p_phoneNo VARCHAR(15),
    IN p_avatarURL TEXT,
    IN p_DoB DATE
)
BEGIN
    INSERT INTO users (id, email, password, firstName, lastName, phoneNo, avatarURL, DoB)
    VALUES (UUID_TO_BIN(p_id), p_email, p_password, p_firstName, p_lastName, p_phoneNo, p_avatarURL, p_DoB);
END$$

-- Update User
CREATE PROCEDURE User_Update(
    IN p_id VARCHAR(36),
    IN p_firstName VARCHAR(50),
    IN p_lastName VARCHAR(50),
    IN p_phoneNo VARCHAR(15),
    IN p_avatarURL TEXT,
    IN p_DoB DATE,
    IN p_isActive BOOLEAN
)
BEGIN
    UPDATE users 
    SET firstName = p_firstName, lastName = p_lastName, phoneNo = p_phoneNo, 
        avatarURL = p_avatarURL, DoB = p_DoB, isActive = p_isActive
    WHERE id = UUID_TO_BIN(p_id);
END$$

-- Delete User (Hard Delete)
CREATE PROCEDURE User_Delete(IN p_id VARCHAR(36))
BEGIN
    DELETE FROM users WHERE id = UUID_TO_BIN(p_id);
END$$

DELIMITER ;

-- client
DELIMITER $$

-- Insert Client
CREATE PROCEDURE Client_Insert(
    IN p_userId VARCHAR(36),
    IN p_slug VARCHAR(10)
)
BEGIN
    INSERT INTO clients (user_id, slug)
    VALUES (UUID_TO_BIN(p_userId), p_slug);
END$$

-- Update Client
CREATE PROCEDURE Client_Update(
    IN p_userId VARCHAR(36),
    IN p_points INT
)
BEGIN
    UPDATE clients 
    SET membership_points = p_points
    WHERE user_id = UUID_TO_BIN(p_userId);
END$$

-- Delete Client
CREATE PROCEDURE Client_Delete(IN p_userId VARCHAR(36))
BEGIN
    DELETE FROM clients WHERE user_id = UUID_TO_BIN(p_userId);
END$$

DELIMITER ;

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
    INSERT INTO owners (user_id, bankId, bankName, accountName, accountNo)
    VALUES (UUID_TO_BIN(p_userId), p_bankId, p_bankName, p_accName, p_accNo);
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
    UPDATE owners 
    SET bankId = p_bankId, bankName = p_bankName, accountName = p_accName, accountNo = p_accNo
    WHERE user_id = UUID_TO_BIN(p_userId);
END$$

-- Delete Owner
CREATE PROCEDURE Owner_Delete(IN p_userId VARCHAR(36))
BEGIN
    DELETE FROM owners WHERE user_id = UUID_TO_BIN(p_userId);
END$$

DELIMITER ;

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

-- venue_type
DELIMITER $$

-- Insert Type
CREATE PROCEDURE VenueType_Insert(
    IN p_id VARCHAR(36),
    IN p_name VARCHAR(50),
    IN p_desc TEXT,
    IN p_minCap INT,
    IN p_maxCap INT,
    IN p_area DECIMAL(10,1)
)
BEGIN
    INSERT INTO venue_types (venueType_id, name, description, minCapacity, maxCapacity, area)
    VALUES (UUID_TO_BIN(p_id), p_name, p_desc, p_minCap, p_maxCap, p_area);
END$$

-- Update Type
CREATE PROCEDURE VenueType_Update(
    IN p_id VARCHAR(36),
    IN p_name VARCHAR(50),
    IN p_desc TEXT,          -- <--- Bổ sung tham số này
    IN p_minCap INT,
    IN p_maxCap INT,
    IN p_area DECIMAL(10,1)
)
BEGIN
    UPDATE venue_types 
    SET name = p_name, description = p_desc, minCapacity = p_minCap, maxCapacity = p_maxCap, area = p_area
    WHERE venueType_id = UUID_TO_BIN(p_id);
END$$

-- Delete Type
CREATE PROCEDURE VenueType_Delete(IN p_id VARCHAR(36))
BEGIN
    DELETE FROM venue_types WHERE venueType_id = UUID_TO_BIN(p_id);
END$$

DELIMITER ;

-- venue
DELIMITER $$

-- Insert Venue
CREATE PROCEDURE Venue_Insert(
    IN p_locId VARCHAR(36),
    IN p_name VARCHAR(100),
    IN p_typeId VARCHAR(36),
    IN p_floor VARCHAR(10),
    IN p_price DECIMAL(10,2)
)
BEGIN
    INSERT INTO venues (location_id, name, venueType_id, floor, pricePerHour)
    VALUES (UUID_TO_BIN(p_locId), p_name, UUID_TO_BIN(p_typeId), p_floor, p_price);
END$$

-- Update Venue
CREATE PROCEDURE Venue_Update(
    IN p_locId VARCHAR(36),
    IN p_name VARCHAR(100),
    IN p_typeId VARCHAR(36), -- <--- Bổ sung tham số này
    IN p_floor VARCHAR(10),
    IN p_price DECIMAL(10,2),
    IN p_isActive BOOLEAN
)
BEGIN
    UPDATE venues 
    SET venueType_id = UUID_TO_BIN(p_typeId), floor = p_floor, pricePerHour = p_price, isActive = p_isActive
    WHERE location_id = UUID_TO_BIN(p_locId) AND name = p_name;
END$$

-- Delete Venue
CREATE PROCEDURE Venue_Delete(
    IN p_locId VARCHAR(36),
    IN p_name VARCHAR(100)
)
BEGIN
    DELETE FROM venues WHERE location_id = UUID_TO_BIN(p_locId) AND name = p_name;
END$$

DELIMITER ;

-- venue images
DELIMITER $$

-- 1. Insert Venue Image
CREATE PROCEDURE VenueImage_Insert(
    IN p_id VARCHAR(36),       -- ID của ảnh (tạo mới từ code)
    IN p_locId VARCHAR(36),    -- ID của địa điểm
    IN p_venueName VARCHAR(100), -- Tên phòng
    IN p_url VARCHAR(255)      -- Link ảnh
)
BEGIN
    INSERT INTO venue_images (image_id, location_id, venueName, locationImgURL)
    VALUES (UUID_TO_BIN(p_id), UUID_TO_BIN(p_locId), p_venueName, p_url);
END$$

-- 2. Update Venue Image
-- Thường chỉ cần sửa đường dẫn ảnh (URL). 
-- Nếu muốn đổi ảnh sang phòng khác, nên Xóa đi tạo lại thay vì Update khóa ngoại.
CREATE PROCEDURE VenueImage_Update(
    IN p_id VARCHAR(36),
    IN p_url VARCHAR(255)
)
BEGIN
    UPDATE venue_images 
    SET locationImgURL = p_url
    WHERE image_id = UUID_TO_BIN(p_id);
END$$

-- 3. Delete Venue Image
CREATE PROCEDURE VenueImage_Delete(IN p_id VARCHAR(36))
BEGIN
    DELETE FROM venue_images WHERE image_id = UUID_TO_BIN(p_id);
END$$

DELIMITER ;

-- amenity
DELIMITER $$

-- Insert Amenity
CREATE PROCEDURE Amenity_Insert(
    IN p_id VARCHAR(36),
    IN p_locId VARCHAR(36),
    IN p_venueName VARCHAR(100),
    IN p_category VARCHAR(50),
    IN p_desc TEXT
)
BEGIN
    INSERT INTO amenities (amenity_id, location_id, venueName, category, description)
    VALUES (UUID_TO_BIN(p_id), UUID_TO_BIN(p_locId), p_venueName, p_category, p_desc);
END$$

-- Update Amenity
CREATE PROCEDURE Amenity_Update(
    IN p_id VARCHAR(36),
    IN p_venueName VARCHAR(100),
    IN p_desc TEXT,
    IN p_isActive BOOLEAN
)
BEGIN
    UPDATE amenities 
    SET venueName = p_venueName, description = p_desc, isActive = p_isActive
    WHERE amenity_id = UUID_TO_BIN(p_id);
END$$

-- Delete Amenity
CREATE PROCEDURE Amenity_Delete(IN p_id VARCHAR(36))
BEGIN
    DELETE FROM amenities WHERE amenity_id = UUID_TO_BIN(p_id);
END$$

DELIMITER ;

-- order
DELIMITER $$

-- Insert Order
CREATE PROCEDURE Order_Insert(
    IN p_id VARCHAR(36),
    IN p_clientId VARCHAR(36),
    IN p_locId VARCHAR(36),
    IN p_venueName VARCHAR(100),
    IN p_totalPrice DECIMAL(12,2),
    IN p_start DATETIME,
    IN p_end DATETIME,
    IN p_points INT
)
BEGIN
    INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, startHour, endHour, points, expiredAt)
    VALUES (UUID_TO_BIN(p_id), UUID_TO_BIN(p_clientId), UUID_TO_BIN(p_locId), p_venueName, p_totalPrice, p_start, p_end, p_points, DATE_ADD(NOW(), INTERVAL 15 MINUTE));
END$$

-- Update Order Status
CREATE PROCEDURE Order_UpdateStatus(
    IN p_id VARCHAR(36),
    IN p_status VARCHAR(20) -- 'CONFIRMED', 'CANCELLED'
)
BEGIN
    UPDATE orders SET status = p_status WHERE order_id = UUID_TO_BIN(p_id);
END$$

-- Delete Order
CREATE PROCEDURE Order_Delete(IN p_id VARCHAR(36))
BEGIN
    DELETE FROM orders WHERE order_id = UUID_TO_BIN(p_id);
END$$

DELIMITER ;

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

-- apply
DELIMITER $$

-- 1. Insert Applies (Áp dụng mã giảm giá cho đơn hàng)
CREATE PROCEDURE Applies_Insert(
    IN p_orderId VARCHAR(36),
    IN p_discountId VARCHAR(36)
)
BEGIN
    -- Có thể thêm logic check trùng (nếu cần), nhưng Primary Key đã tự lo việc đó
    INSERT INTO applies (order_id, discount_id)
    VALUES (UUID_TO_BIN(p_orderId), UUID_TO_BIN(p_discountId));
END$$

-- 2. Update Applies (Đổi mã giảm giá này sang mã khác cho cùng 1 đơn)
-- Logic: Thay discount cũ bằng discount mới cho order đó
CREATE PROCEDURE Applies_Update(
    IN p_orderId VARCHAR(36),
    IN p_oldDiscountId VARCHAR(36), -- Mã cũ muốn thay
    IN p_newDiscountId VARCHAR(36)  -- Mã mới muốn áp dụng
)
BEGIN
    UPDATE applies 
    SET discount_id = UUID_TO_BIN(p_newDiscountId)
    WHERE order_id = UUID_TO_BIN(p_orderId) 
      AND discount_id = UUID_TO_BIN(p_oldDiscountId);
END$$

-- 3. Delete Applies (Gỡ bỏ mã giảm giá khỏi đơn hàng)
CREATE PROCEDURE Applies_Delete(
    IN p_orderId VARCHAR(36),
    IN p_discountId VARCHAR(36)
)
BEGIN
    DELETE FROM applies 
    WHERE order_id = UUID_TO_BIN(p_orderId) 
      AND discount_id = UUID_TO_BIN(p_discountId);
END$$

DELIMITER ;

-- invoice
DELIMITER $$

-- 1. Invoice_Create (TỐI ƯU: Bỏ tham số status)
CREATE PROCEDURE Invoice_Create(
    IN p_id VARCHAR(36),
    IN p_orderId VARCHAR(36),
    IN p_amount DECIMAL(12,2)
)
BEGIN
    -- Chỉ insert 3 cột cốt lõi. 
    -- Cột 'status' sẽ tự động nhận giá trị 'PENDING' từ Default của bảng.
    -- Các cột bank, transaction, paidOn, description sẽ tự nhận NULL.
    INSERT INTO invoices (
        invoice_id, 
        order_id, 
        amount
    )
    VALUES (
        UUID_TO_BIN(p_id), 
        UUID_TO_BIN(p_orderId), 
        p_amount
    );
END$$

-- 2. Invoice_CompletePayment
-- THÊM tham số p_desc để nhận nội dung từ ngân hàng (VD: "KH Tran Van A chuyen khoan...")
CREATE PROCEDURE Invoice_CompletePayment(
    IN p_id VARCHAR(36),
    IN p_senderBank VARCHAR(50),
    IN p_recvBank VARCHAR(50),
    IN p_transId VARCHAR(50),
    IN p_desc TEXT  -- <--- Bổ sung tham số này
)
BEGIN
    UPDATE invoices 
    SET 
        status = 'SUCCEEDED',
        senderBankAccount = p_senderBank,
        receiverBankAccount = p_recvBank,
        transaction_id = p_transId,
        description = p_desc, -- <--- Cập nhật nội dung tại đây
        paidOn = NOW()
    WHERE invoice_id = UUID_TO_BIN(p_id);
END$$

-- 3. Invoice_UpdateStatus (Dùng cho FAILED/REFUNDED)
-- Cũng nên cho phép cập nhật lý do lỗi vào description
CREATE PROCEDURE Invoice_UpdateStatus(
    IN p_id VARCHAR(36),
    IN p_status VARCHAR(20),
    IN p_desc TEXT -- <--- Thêm lý do lỗi (VD: "Số dư không đủ")
)
BEGIN
    UPDATE invoices 
    SET 
        status = p_status,
        description = p_desc
    WHERE invoice_id = UUID_TO_BIN(p_id);
END$$

-- 4. Invoice_Delete (Giữ nguyên)
CREATE PROCEDURE Invoice_Delete(IN p_id VARCHAR(36))
BEGIN
    DELETE FROM invoices WHERE invoice_id = UUID_TO_BIN(p_id);
END$$

DELIMITER ;

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