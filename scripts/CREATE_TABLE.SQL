CREATE TABLE users (
    id VARCHAR(255) PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE CHECK (email LIKE '%_@__%.__%'), -- Basic regex check
    password VARCHAR(255) NOT NULL,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    phoneNo VARCHAR(15) CHECK (LENGTH(phoneNo) = 10),
    avatarURL VARCHAR(255),
    DoB DATE, -- valid
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE clients (
    user_id VARCHAR(255) PRIMARY KEY,
    slug VARCHAR(10) NOT NULL UNIQUE,
    membership_points INT DEFAULT 0,
    membership_tier VARCHAR(20) DEFAULT 'BRONZE',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE owners (
    user_id VARCHAR(255) PRIMARY KEY,
    bankId VARCHAR(50) NOT NULL, -- limited set
    bankName VARCHAR(100) NOT NULL, -- limited set
    accountName VARCHAR(100) NOT NULL,
    accountNo VARCHAR(50) NOT NULL UNIQUE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE locations (
    location_id VARCHAR(255) PRIMARY KEY,
    owner_id VARCHAR(255) NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    addrNo VARCHAR(20) NOT NULL,
    ward VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    avgRating DECIMAL(2,1) DEFAULT 0,
    policy TEXT,
    phoneNo VARCHAR(15), -- == 10
    mapURL VARCHAR(255) NOT NULL UNIQUE,
    thumbnailURL VARCHAR(255) NOT NULL UNIQUE,
    isActive BOOLEAN DEFAULT 1,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES owners(user_id) ON DELETE CASCADE
);

CREATE TABLE venue_types (
    venueType_id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    pricePerHour DECIMAL(10, 2) NOT NULL,
    capacity INT,
    area DECIMAL(10, 1) NOT NULL,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE venues (
    location_id VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    venueType_id VARCHAR(255),
    floor VARCHAR(10),
    isActive BOOLEAN DEFAULT 1,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (location_id, name),
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE,
    FOREIGN KEY (venueType_id) REFERENCES venue_types(venueType_id) ON DELETE SET NULL
);

CREATE TABLE venue_images (
    location_id VARCHAR(255) NOT NULL,
    venueName VARCHAR(100) NOT NULL,
    locationImgURL VARCHAR(255) NOT NULL,
    PRIMARY KEY (location_id, venueName, locationImgURL),
    FOREIGN KEY (location_id, venueName) REFERENCES venues(location_id, name) ON DELETE CASCADE
);

CREATE TABLE amenities (
    amenity_id VARCHAR(255) PRIMARY KEY,
    location_id VARCHAR(255) NOT NULL, 
    venueName VARCHAR(100), 
    category VARCHAR(50), -- Audience_Chairs, Table_Chairs, Cooling_Fan, Stage_Platform, Sound_System, Heater, Banquet_Furniture, Birthday_Furniture, Projector_Kit, Smartboard_Kit, Studio_Gear
    description TEXT,
    icon VARCHAR(255),
    status VARCHAR(50) NOT NULL, -- STORAGE, FIXING, USED
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id, venueName) REFERENCES venues(location_id, name) ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id VARCHAR(255) PRIMARY KEY,
    client_id VARCHAR(255),
    venue_loc_id VARCHAR(255),
    venueName VARCHAR(255),
    totalPrice DECIMAL(12, 2) NOT NULL CHECK (totalPrice > 0),
    status VARCHAR(20) NOT NULL, -- Pending, Confirmed, Cancelled
    startHour DATETIME NOT NULL,
    endHour DATETIME NOT NULL,
    bookingDate DATETIME, -- > current
    points INT NOT NULL,
    expiredAt DATETIME NOT NULL,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    CHECK (endHour > startHour),
    FOREIGN KEY (client_id) REFERENCES clients(user_id) ON DELETE SET NULL,
    FOREIGN KEY (venue_loc_id, venueName) REFERENCES venues(location_id, name) ON DELETE SET NULL
);

CREATE TABLE discounts (
    discount_id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    percentage DECIMAL(5, 2),
    maxDiscountPrice DECIMAL(12, 2), -- CHECK, >0
    minPrice DECIMAL(12, 2), -- CHECK, >0
    venueType VARCHAR(50), -- CHECK SET VENUE_TYPE
    membershipTier VARCHAR(20), -- CHECK SET MEMBERSHIP
    startedAt DATETIME NOT NULL,
    expiredAt DATETIME NOT NULL,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    CHECK (expiredAt > startedAt)
);

CREATE TABLE applies (
    order_id VARCHAR(255) NOT NULL,
    discount_id VARCHAR(255) NOT NULL,
    PRIMARY KEY (order_id, discount_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (discount_id) REFERENCES discounts(discount_id) ON DELETE CASCADE
);

CREATE TABLE invoices (
    invoice_id VARCHAR(255) PRIMARY KEY,
    order_id VARCHAR(255) UNIQUE,
    amount DECIMAL(12, 2) NOT NULL CHECK (amount > 0),
    status VARCHAR(20), -- CHECK SET
    senderBankAccount VARCHAR(50) NOT NULL,
    receiverBankAccount VARCHAR(50) NOT NULL,
    transaction_id VARCHAR(100) NOT NULL UNIQUE,
    paidOn DATETIME NOT NULL,
    description TEXT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE SET NULL
);

CREATE TABLE rates (
    client_id VARCHAR(255),
    location_id VARCHAR(255),
    stars INT CHECK (stars BETWEEN 1 AND 5),
    comment TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (client_id, location_id),
    FOREIGN KEY (client_id) REFERENCES clients(user_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE
);

CREATE TABLE favors (
    client_id VARCHAR(255) NOT NULL,
    location_id VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (client_id, location_id),
    FOREIGN KEY (client_id) REFERENCES clients(user_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE
);

CREATE TABLE chats (
    message_id VARCHAR(255) PRIMARY KEY,
    sender_id VARCHAR(255) NOT NULL,
    receiver_id VARCHAR(255) NOT NULL,
    content TEXT,
    sentAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(user_id),
    FOREIGN KEY (receiver_id) REFERENCES users(user_id)
);