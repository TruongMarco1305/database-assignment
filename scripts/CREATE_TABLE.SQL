CREATE TABLE users (
    id BINARY(16) PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE CHECK (email REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$'),
    password VARCHAR(255) NOT NULL CHECK (LENGTH(password) >= 8 AND password NOT LIKE '% %'),
    firstName VARCHAR(50) CHECK (firstName REGEXP '^[A-Za-z]+$'),
    lastName VARCHAR(50) CHECK (lastName REGEXP '^[A-Za-z]+$'),
    phoneNo VARCHAR(10) CHECK (phoneNo REGEXP '^[0-9]+$'),
    avatarURL TEXT,
    DoB DATE NOT NULL,
    isActive BOOLEAN DEFAULT 1,
    isAdmin BOOLEAN DEFAULT 0,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE clients (
    user_id BINARY(16) PRIMARY KEY,
    slug VARCHAR(10) NOT NULL UNIQUE,
    membership_points INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT
);

CREATE TABLE owners (
    user_id BINARY(16) PRIMARY KEY,
    bankId VARCHAR(50) NOT NULL, -- limited set
    bankName VARCHAR(100) NOT NULL, -- limited set
    accountName VARCHAR(50) NOT NULL,
    accountNo VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT
);

CREATE TABLE locations (
    location_id BINARY(16) PRIMARY KEY,
    owner_id BINARY(16) NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    addrNo VARCHAR(20) NOT NULL,
    ward VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    avgRating DECIMAL(2,1) DEFAULT 0,
    policy TEXT,
    phoneNo VARCHAR(10) CHECK (phoneNo REGEXP '^[0-9]+$'),
    mapURL VARCHAR(255) NOT NULL,
    thumbnailURL VARCHAR(255) NOT NULL,
    isActive BOOLEAN DEFAULT 1,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES owners(user_id) ON DELETE RESTRICT
);

CREATE TABLE venue_types ( 
    venueType_id BINARY(16) PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE, -- Minimalist, Luxury, Outdoor
    description TEXT,
    minCapacity INT NOT NULL CHECK (minCapacity > 0), -- 3 type small 0-40, medium 40-80, large 80-120
    maxCapacity INT NOT NULL CHECK (maxCapacity > 0),
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CHECK (maxCapacity >= minCapacity)
);

CREATE TABLE venues (
    location_id BINARY(16) NOT NULL,
    name VARCHAR(100) NOT NULL,
    venueType_id BINARY(16),
    floor VARCHAR(10) NOT NULL,
    area DECIMAL(10, 1) NOT NULL CHECK (area > 0),
    pricePerHour DECIMAL(10, 2) NOT NULL CHECK (pricePerHour > 0),
    isActive BOOLEAN DEFAULT 1,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (location_id, name),
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE,
    FOREIGN KEY (venueType_id) REFERENCES venue_types(venueType_id) ON DELETE RESTRICT
);

CREATE TABLE venue_images (
    image_id BINARY(16) PRIMARY KEY,
    location_id BINARY(16) NOT NULL,
    venueName VARCHAR(100) NOT NULL,
    locationImgURL VARCHAR(255) NOT NULL,
    FOREIGN KEY (location_id, venueName) REFERENCES venues(location_id, name) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE amenities (
    amenity_id BINARY(16) PRIMARY KEY,
    location_id BINARY(16) NOT NULL, 
    category VARCHAR(50) NOT NULL,
    description TEXT,
    price DECIMAL(12, 2) NOT NULL DEFAULT 0 CHECK (price >= 0), -- THÊM CỘT GIÁ (Giá thuê niêm yết)
    compatibleSize SET('Small', 'Medium', 'Large') DEFAULT NULL, -- NULL là cho mọi size
    isActive BOOLEAN DEFAULT 1, -- 1 là đang trong kho sẵn sàng phục vụ, 0 thì là đang dùng hoặc hỏng
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE
    -- FOREIGN KEY (location_id, venueName) REFERENCES venues(location_id, name) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE orders (
    order_id BINARY(16) PRIMARY KEY,
    client_id BINARY(16),
    venue_loc_id BINARY(16),
    venueName VARCHAR(100),
    totalPrice DECIMAL(12, 2) NOT NULL CHECK (totalPrice > 0),
    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING',
    startHour DATETIME NOT NULL,
    endHour DATETIME NOT NULL,
    points INT NOT NULL,
    expiredAt DATETIME NOT NULL,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(user_id) ON DELETE RESTRICT,
    FOREIGN KEY (venue_loc_id, venueName) REFERENCES venues(location_id, name) ON DELETE SET NULL ON UPDATE CASCADE,
    CHECK (HOUR(startHour) >= 6 AND HOUR(endHour) <= 23 AND DATE(startHour) = DATE(endHour)),
    CHECK (endHour > startHour),
    CHECK (startHour >= DATE_ADD(createdAt, INTERVAL 4 HOUR)) -- phải được đặt trước 4 tiếng
);

CREATE TABLE order_amenities (
    order_id BINARY(16) NOT NULL,
    amenity_id BINARY(16) NOT NULL,
    
    PRIMARY KEY (order_id, amenity_id),
    
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (amenity_id) REFERENCES amenities(amenity_id) ON DELETE RESTRICT
);

CREATE TABLE discounts (
    discount_id BINARY(16) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    percentage INT NOT NULL CHECK (percentage BETWEEN 0 AND 100),
    maxDiscountPrice DECIMAL(12, 2),
    minPrice DECIMAL(12, 2),
    venueTypeId BINARY(16),
    membershipTier SET('BRONZE', 'SILVER', 'GOLD', 'PLATINUM'), -- CHECK SET MEMBERSHIP
    startedAt DATETIME NOT NULL,
    expiredAt DATETIME NOT NULL,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (venueTypeId) REFERENCES venue_types(venueType_id) ON DELETE CASCADE,
    CHECK (expiredAt > startedAt),
    CHECK (maxDiscountPrice IS NULL OR maxDiscountPrice > 0),
    CHECK (minPrice IS NULL OR minPrice > 0)
);

CREATE TABLE applies (
    order_id BINARY(16) NOT NULL,
    discount_id BINARY(16) NOT NULL,
    PRIMARY KEY (order_id, discount_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (discount_id) REFERENCES discounts(discount_id) ON DELETE CASCADE
);

CREATE TABLE invoices (
    invoice_id BINARY(16) PRIMARY KEY,
    order_id BINARY(16),
    amount DECIMAL(12, 2) NOT NULL CHECK (amount > 0),
    status ENUM('PENDING', 'SUCCEEDED', 'FAILED', 'REFUNDED') DEFAULT 'PENDING',
    senderBankAccount VARCHAR(50),
    receiverBankAccount VARCHAR(50),
    transaction_id VARCHAR(50),
    paidOn DATETIME,
    description TEXT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE SET NULL
);

CREATE TABLE rates (
    client_id BINARY(16),
    location_id BINARY(16),
    stars INT CHECK (stars BETWEEN 1 AND 5), 
    comment TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (client_id, location_id),
    FOREIGN KEY (client_id) REFERENCES clients(user_id) ON DELETE RESTRICT,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE
);

CREATE TABLE favors (
    client_id BINARY(16) NOT NULL,
    location_id BINARY(16) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (client_id, location_id),
    FOREIGN KEY (client_id) REFERENCES clients(user_id) ON DELETE RESTRICT,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE
);