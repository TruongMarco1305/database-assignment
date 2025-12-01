-- =============================================================================
-- DỮ LIỆU MẪU: 20 ĐƠN HÀNG ĐÃ HOÀN TẤT (CÓ GIÁ & ĐIỂM)
-- Logic điểm: 10.000 VND = 1 điểm
-- =============================================================================

-- 1. Khách Alice (User 1)
-- 1.1. Grand Sunrise Hall (5tr/h x 4h = 20tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('11111111-1111-1111-1111-111111111111'), UUID_TO_BIN('10101010-1010-1010-1010-101010101001'), 'Grand Sunrise Hall', 20000000.00, 'COMPLETED', '2023-01-15 08:00:00', '2023-01-15 12:00:00', 2000, '2023-01-15 00:00:00', '2023-01-10 00:00:00');

-- 1.2. Training Room A (800k/h x 2h = 1.6tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('11111111-1111-1111-1111-111111111111'), UUID_TO_BIN('10101010-1010-1010-1010-101010101002'), 'Training Room A', 1600000.00, 'COMPLETED', '2023-02-20 14:00:00', '2023-02-20 16:00:00', 160, '2023-02-20 00:00:00', '2023-02-15 00:00:00');


-- 2. Khách Bob (User 2)
-- 2.1. Training Room B (750k/h x 2h = 1.5tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('22222222-2222-2222-2222-222222222222'), UUID_TO_BIN('10101010-1010-1010-1010-101010101002'), 'Training Room B', 1500000.00, 'COMPLETED', '2023-03-05 09:00:00', '2023-03-05 11:00:00', 150, '2023-03-05 00:00:00', '2023-03-01 00:00:00');

-- 2.2. Grace Ballroom (12tr/h x 4h = 48tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('22222222-2222-2222-2222-222222222222'), UUID_TO_BIN('20202020-2020-2020-2020-202020202001'), 'Grace Ballroom', 48000000.00, 'COMPLETED', '2023-03-10 18:00:00', '2023-03-10 22:00:00', 4800, '2023-03-10 00:00:00', '2023-03-05 00:00:00');


-- 3. Khách Charlie (User 3)
-- 3.1. Garden Foyer (3tr/h x 3h = 9tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('33333333-3333-3333-3333-333333333333'), UUID_TO_BIN('20202020-2020-2020-2020-202020202001'), 'Garden Foyer', 9000000.00, 'COMPLETED', '2023-04-12 15:00:00', '2023-04-12 18:00:00', 900, '2023-04-12 00:00:00', '2023-04-10 00:00:00');

-- 3.2. Photo Studio 1 (500k/h x 4h = 2tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('33333333-3333-3333-3333-333333333333'), UUID_TO_BIN('20202020-2020-2020-2020-202020202002'), 'Photo Studio 1', 2000000.00, 'COMPLETED', '2023-04-25 08:00:00', '2023-04-25 12:00:00', 200, '2023-04-25 00:00:00', '2023-04-20 00:00:00');


-- 4. Khách David (User 4)
-- 4.1. Creative Hub (900k/h x 4h = 3.6tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('44444444-4444-4444-4444-444444444444'), UUID_TO_BIN('20202020-2020-2020-2020-202020202002'), 'Creative Hub', 3600000.00, 'COMPLETED', '2023-05-01 13:00:00', '2023-05-01 17:00:00', 360, '2023-05-01 00:00:00', '2023-04-28 00:00:00');

-- 4.2. Royal Banquet Hall (15tr/h x 4h = 60tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('44444444-4444-4444-4444-444444444444'), UUID_TO_BIN('30303030-3030-3030-3030-303030303001'), 'Royal Banquet Hall', 60000000.00, 'COMPLETED', '2023-05-20 18:00:00', '2023-05-20 22:00:00', 6000, '2023-05-20 00:00:00', '2023-05-10 00:00:00');


-- 5. Khách Eve (User 5)
-- 5.1. Private Dining Room (4tr/h x 2h = 8tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('55555555-5555-5555-5555-555555555555'), UUID_TO_BIN('30303030-3030-3030-3030-303030303001'), 'Private Dining Room', 8000000.00, 'COMPLETED', '2023-06-15 19:00:00', '2023-06-15 21:00:00', 800, '2023-06-15 00:00:00', '2023-06-10 00:00:00');

-- 5.2. Meeting Suite A (200k/h x 2h = 400k)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('55555555-5555-5555-5555-555555555555'), UUID_TO_BIN('30303030-3030-3030-3030-303030303002'), 'Meeting Suite A', 400000.00, 'COMPLETED', '2023-07-01 09:00:00', '2023-07-01 11:00:00', 40, '2023-07-01 00:00:00', '2023-06-25 00:00:00');


-- 6. Khách Frank (User 6)
-- 6.1. Interview Room (150k/h x 2h = 300k)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('66666666-6666-6666-6666-666666666666'), UUID_TO_BIN('30303030-3030-3030-3030-303030303002'), 'Interview Room', 300000.00, 'COMPLETED', '2023-07-10 14:00:00', '2023-07-10 16:00:00', 30, '2023-07-10 00:00:00', '2023-07-05 00:00:00');

-- 6.2. Sky Bar Area (2.5tr/h x 5h = 12.5tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('66666666-6666-6666-6666-666666666666'), UUID_TO_BIN('40404040-4040-4040-4040-404040404001'), 'Sky Bar Area', 12500000.00, 'COMPLETED', '2023-08-05 18:00:00', '2023-08-05 23:00:00', 1250, '2023-08-05 00:00:00', '2023-08-01 00:00:00');


-- 7. Khách Grace (User 7)
-- 7.1. BBQ Corner (1tr/h x 4h = 4tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('77777777-7777-7777-7777-777777777777'), UUID_TO_BIN('40404040-4040-4040-4040-404040404001'), 'BBQ Corner', 4000000.00, 'COMPLETED', '2023-08-20 17:00:00', '2023-08-20 21:00:00', 400, '2023-08-20 00:00:00', '2023-08-15 00:00:00');

-- 7.2. Conference Hall B (3tr/h x 9h = 27tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('77777777-7777-7777-7777-777777777777'), UUID_TO_BIN('40404040-4040-4040-4040-404040404002'), 'Conference Hall B', 27000000.00, 'COMPLETED', '2023-09-10 08:00:00', '2023-09-10 17:00:00', 2700, '2023-09-10 00:00:00', '2023-09-01 00:00:00');


-- 8. Khách Heidi (User 8)
-- 8.1. Board Room (1.2tr/h x 2h = 2.4tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('88888888-8888-8888-8888-888888888888'), UUID_TO_BIN('40404040-4040-4040-4040-404040404002'), 'Board Room', 2400000.00, 'COMPLETED', '2023-09-15 10:00:00', '2023-09-15 12:00:00', 240, '2023-09-15 00:00:00', '2023-09-12 00:00:00');

-- 8.2. Main Gallery (4tr/h x 12h = 48tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('88888888-8888-8888-8888-888888888888'), UUID_TO_BIN('50505050-5050-5050-5050-505050505001'), 'Main Gallery', 48000000.00, 'COMPLETED', '2023-10-05 09:00:00', '2023-10-05 21:00:00', 4800, '2023-10-05 00:00:00', '2023-09-30 00:00:00');


-- 9. Khách Ivan (User 9)
-- 9.1. Pop-up Store Area (1tr/h x 12h = 12tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('99999999-9999-9999-9999-999999999999'), UUID_TO_BIN('50505050-5050-5050-5050-505050505001'), 'Pop-up Store Area', 12000000.00, 'COMPLETED', '2023-11-11 08:00:00', '2023-11-11 20:00:00', 1200, '2023-11-11 00:00:00', '2023-11-01 00:00:00');

-- 9.2. Pottery Studio (400k/h x 3h = 1.2tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('99999999-9999-9999-9999-999999999999'), UUID_TO_BIN('50505050-5050-5050-5050-505050505002'), 'Pottery Studio', 1200000.00, 'COMPLETED', '2023-11-20 14:00:00', '2023-11-20 17:00:00', 120, '2023-11-20 00:00:00', '2023-11-15 00:00:00');


-- 10. Khách Judy (User 10)
-- 10.1. Art Garden (500k/h x 3h = 1.5tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'), UUID_TO_BIN('50505050-5050-5050-5050-505050505002'), 'Art Garden', 1500000.00, 'COMPLETED', '2023-12-05 08:00:00', '2023-12-05 11:00:00', 150, '2023-12-05 00:00:00', '2023-12-01 00:00:00');

-- 10.2. Sunrise VIP Suite (1.5tr/h x 4h = 6tr)
INSERT INTO orders (order_id, client_id, venue_loc_id, venueName, totalPrice, status, startHour, endHour, points, expiredAt, createdAt) VALUES
(UUID_TO_BIN(UUID()), UUID_TO_BIN('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'), UUID_TO_BIN('10101010-1010-1010-1010-101010101001'), 'Sunrise VIP Suite', 6000000.00, 'COMPLETED', '2023-12-25 18:00:00', '2023-12-25 22:00:00', 600, '2023-12-25 00:00:00', '2023-12-20 00:00:00');