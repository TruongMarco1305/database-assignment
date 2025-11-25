CREATE TABLE users (
    id BINARY(16) PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE CHECK (email REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$'),
    password VARCHAR(255) NOT NULL,
    firstName VARCHAR(50) CHECK (firstName REGEXP '^[A-Za-z]+$'),
    lastName VARCHAR(50) CHECK (lastName REGEXP '^[A-Za-z]+$'),
    phoneNo VARCHAR(15) CHECK (phoneNo REGEXP '^[0-9]+$'),
    avatarURL TEXT,
    DoB DATE NOT NULL,
    isActive BOOLEAN DEFAULT 1,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE clients (
    user_id BINARY(16) PRIMARY KEY,
    slug VARCHAR(10) NOT NULL UNIQUE,
    membership_points INT DEFAULT 0,
    membership_tier ENUM('BRONZE', 'SILVER', 'GOLD', 'PLATINUM') DEFAULT 'BRONZE',
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
    phoneNo VARCHAR(15) CHECK (phoneNo REGEXP '^[0-9]+$'),
    mapURL VARCHAR(255) NOT NULL,
    thumbnailURL VARCHAR(255) NOT NULL,
    isActive BOOLEAN DEFAULT 1,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES owners(user_id) ON DELETE RESTRICT
);

CREATE TABLE venue_types (
    venueType_id BINARY(16) PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    capacity INT NOT NULL CHECK (capacity > 0),
    area DECIMAL(10, 1) NOT NULL CHECK (area > 0),
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE venues (
    location_id BINARY(16) NOT NULL,
    name VARCHAR(100) NOT NULL,
    venueType_id BINARY(16),
    floor VARCHAR(10) NOT NULL,
    pricePerHour DECIMAL(10, 2) NOT NULL CHECK (pricePerHour > 0),
    isActive BOOLEAN DEFAULT 1,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (location_id, name),
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE,
    FOREIGN KEY (venueType_id) REFERENCES venue_types(venueType_id) ON DELETE SET NULL
);

CREATE TABLE venue_images (
    image_id BINARY(16) PRIMARY KEY,
    location_id BINARY(16) NOT NULL,
    venueName VARCHAR(100) NOT NULL,
    locationImgURL VARCHAR(255) NOT NULL,
    FOREIGN KEY (location_id, venueName) REFERENCES venues(location_id, name) ON DELETE CASCADE
);

CREATE TABLE amenities (
    amenity_id BINARY(16) PRIMARY KEY,
    location_id BINARY(16) NOT NULL, 
    venueName VARCHAR(100) NOT NULL, 
    category VARCHAR(50) NOT NULL,
    description TEXT,
    isActive BOOLEAN DEFAULT 1,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id, venueName) REFERENCES venues(location_id, name) ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id BINARY(16) PRIMARY KEY,
    client_id BINARY(16),
    venue_loc_id BINARY(16),
    venueName VARCHAR(50),
    totalPrice DECIMAL(12, 2) NOT NULL CHECK (totalPrice > 0),
    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED') DEFAULT 'PENDING',
    startHour DATETIME NOT NULL,
    endHour DATETIME NOT NULL,
    points INT NOT NULL,
    expiredAt DATETIME NOT NULL,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(user_id) ON DELETE RESTRICT,
    FOREIGN KEY (venue_loc_id, venueName) REFERENCES venues(location_id, name) ON DELETE SET NULL,
    CHECK (HOUR(startHour) >= 6 AND HOUR(endHour) <= 23 AND DATE(startHour) = DATE(endHour)),
    CHECK (endHour > startHour)
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
    status ENUM('PENDING', 'SUCCEEDED', 'FAILED', 'REFUNDED'),
    senderBankAccount VARCHAR(50) NOT NULL,
    receiverBankAccount VARCHAR(50) NOT NULL,
    transaction_id VARCHAR(50) NOT NULL,
    paidOn DATETIME NOT NULL,
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