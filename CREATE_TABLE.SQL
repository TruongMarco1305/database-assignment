CREATE TABLE USERS (
    user_id VARCHAR(255) PRIMARY KEY,
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

CREATE TABLE CLIENTS (
    user_id VARCHAR(255) PRIMARY KEY,
    slug VARCHAR(10) NOT NULL UNIQUE,
    membership_points INT DEFAULT 0,
    membership_tier VARCHAR(20) DEFAULT 'BRONZE',
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

CREATE TABLE OWNERS (
    user_id VARCHAR(255) PRIMARY KEY,
    bankId VARCHAR(50) NOT NULL, -- limited set
    bankName VARCHAR(100) NOT NULL, -- limited set
    accountName VARCHAR(100) NOT NULL,
    accountNo VARCHAR(50) NOT NULL UNIQUE,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

CREATE TABLE LOCATIONS (
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
    FOREIGN KEY (owner_id) REFERENCES OWNERS(user_id) ON DELETE CASCADE
);

CREATE TABLE VENUE_TYPES (
    venueType_id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    pricePerHour DECIMAL(10, 2) NOT NULL,
    capacity INT,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE VENUES (
    location_id VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    venueType_id VARCHAR(255),
    floor VARCHAR(10),
    isActive BOOLEAN DEFAULT 1,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (location_id, name),
    FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id) ON DELETE CASCADE,
    FOREIGN KEY (venueType_id) REFERENCES VENUE_TYPES(venueType_id) ON DELETE SET NULL
);

CREATE TABLE Venue_Images (
    location_id VARCHAR(255) NOT NULL,
    venueName VARCHAR(100) NOT NULL,
    locationImgURL VARCHAR(255) NOT NULL,
    PRIMARY KEY (location_id, venueName, locationImgURL),
    FOREIGN KEY (location_id, venueName) REFERENCES VENUES(location_id, name) ON DELETE CASCADE
);

CREATE TABLE AMENITIES (
    amenity_id VARCHAR(255) PRIMARY KEY,
    location_id VARCHAR(255) NOT NULL, 
    venueName VARCHAR(100), 
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    description TEXT,
    icon VARCHAR(255),
    status VARCHAR(50) NOT NULL, -- STORAGE, FIXING, USED
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id, venueName) REFERENCES VENUES(location_id, name) ON DELETE RESTRICT
);

CREATE TABLE ORDERS (
    order_id VARCHAR(255) PRIMARY KEY,
    client_id VARCHAR(255),
    venue_loc_id VARCHAR(255),
    venueName VARCHAR(255),
    totalPrice DECIMAL(12, 2) NOT NULL CHECK (totalPrice > 0),
    status VARCHAR(20) NOT NULL, -- Pending, Confirmed, Cancelled
    startHour DATETIME NOT NULL,
    endHour DATETIME NOT NULL,
    bookingDate DATETIME, -- > current
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    CHECK (endHour > startHour),
    FOREIGN KEY (client_id) REFERENCES CLIENTS(user_id) ON DELETE SET NULL,
    FOREIGN KEY (venue_loc_id, venueName) REFERENCES VENUES(location_id, name) ON DELETE SET NULL
);

CREATE TABLE DISCOUNTS (
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

CREATE TABLE APPLIES (
    order_id VARCHAR(255) NOT NULL,
    discount_id VARCHAR(255) NOT NULL,
    PRIMARY KEY (order_id, discount_id),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id) ON DELETE CASCADE,
    FOREIGN KEY (discount_id) REFERENCES DISCOUNTS(discount_id) ON DELETE CASCADE
);

CREATE TABLE INVOICES (
    invoice_id VARCHAR(255) PRIMARY KEY,
    order_id VARCHAR(255) UNIQUE,
    amount DECIMAL(12, 2) NOT NULL CHECK (amount > 0),
    status VARCHAR(20), -- CHECK SET
    senderBankAccount VARCHAR(50) NOT NULL,
    receiverBankAccount VARCHAR(50) NOT NULL,
    transaction_id VARCHAR(100) NOT NULL UNIQUE,
    paidOn DATETIME NOT NULL,
    description TEXT,
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id) ON DELETE SET NULL
);

CREATE TABLE RATES (
    client_id VARCHAR(255),
    location_id VARCHAR(255),
    stars INT CHECK (stars BETWEEN 1 AND 5),
    comment TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (client_id, location_id),
    FOREIGN KEY (client_id) REFERENCES CLIENTS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id) ON DELETE CASCADE
);

CREATE TABLE FAVORS (
    client_id VARCHAR(255) NOT NULL,
    location_id VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (client_id, location_id),
    FOREIGN KEY (client_id) REFERENCES CLIENTS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id) ON DELETE CASCADE
);

CREATE TABLE CHATS (
    message_id VARCHAR(255) PRIMARY KEY,
    sender_id VARCHAR(255) NOT NULL,
    receiver_id VARCHAR(255) NOT NULL,
    content TEXT,
    sentAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES USERS(user_id),
    FOREIGN KEY (receiver_id) REFERENCES USERS(user_id)
);