-- Locations for Frank Ho (owner user_id = '66666666-6666-6666-6666-666666666666')

-- Sunrise Conference Hall
CALL Venue_Insert(
    '10101010-1010-1010-1010-101010101001', -- p_locId
    'Main Hall',                            -- p_name
    '12121212-1212-1212-1212-121212121212', -- p_typeId
    '1',                                    -- p_floor
    150.00                                  -- p_price
);

-- Sunrise Annex
CALL Venue_Insert(
    '10101010-1010-1010-1010-101010101002',
    'Annex Room',
    '14141414-1414-1414-1414-141414141414',
    '1',
    60.00
);

-- Locations for Grace Lam (owner user_id = '77777777-7777-7777-7777-777777777777')

-- Grace Events Center
CALL Venue_Insert(
    '20202020-2020-2020-2020-202020202001',
    'Grand Ballroom',
    '13131313-1313-1313-1313-131313131313',
    'Ground',
    200.00
);

-- Grace Studio Rooms
CALL Venue_Insert(
    '20202020-2020-2020-2020-202020202002',
    'Studio A',
    '15151515-1515-1515-1515-151515151515',
    '2',
    45.50
);

-- Locations for Heidi Kim (owner user_id = '88888888-8888-8888-8888-888888888888')

-- Heidi Banquet Hall
CALL Venue_Insert(
    '30303030-3030-3030-3030-303030303001',
    'Banquet Main',
    '13131313-1313-1313-1313-131313131313',
    '1',
    180.00
);

-- Heidi Meeting Suites
CALL Venue_Insert(
    '30303030-3030-3030-3030-303030303002',
    'Suite 1',
    '14141414-1414-1414-1414-141414141414',
    '3',
    55.00
);

-- Locations for Ivan Tran (owner user_id = '99999999-9999-9999-9999-999999999999')

-- Ivan Rooftop Venue
CALL Venue_Insert(
    '40404040-4040-4040-4040-404040404001',
    'Rooftop Deck',
    '16161616-1616-1616-1616-161616161616',
    'R',
    120.00
);

-- Ivan Conference Rooms
CALL Venue_Insert(
    '40404040-4040-4040-4040-404040404002',
    'Conference B',
    '12121212-1212-1212-1212-121212121212',
    '2',
    130.00
);

-- Locations for Judy Nguyen (owner user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa')

-- Judy Event Space
CALL Venue_Insert(
    '50505050-5050-5050-5050-505050505001',
    'Exhibit Hall',
    '13131313-1313-1313-1313-131313131313',
    '1',
    90.00
);

-- Judy Workshop Hub
CALL Venue_Insert(
    '50505050-5050-5050-5050-505050505002',
    'Workshop Room',
    '15151515-1515-1515-1515-151515151515',
    'G',
    35.00
);