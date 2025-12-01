-- =============================================================================
-- LOCATION 1: Sunrise Conference Hall (Chuyên sự kiện lớn - Large/Exclusive)
-- ID: 10101010-1010-1010-1010-101010101001
-- =============================================================================
-- 1. Projector (Large)
CALL Amenity_Insert('aaaa1111-aaaa-aaaa-aaaa-000000000001', '10101010-1010-1010-1010-101010101001', 'Projector', 'High-Lumen Laser Projector & 200" Screen', 800000, 'Large');
-- 2. Catering (Large)
CALL Amenity_Insert('aaaa1111-aaaa-aaaa-aaaa-000000000002', '10101010-1010-1010-1010-101010101001', 'Catering', 'Full Buffet Service (Asian/Western)', 400000, 'Large');
-- 3. Audio Set (Universal)
CALL Amenity_Insert('aaaa1111-aaaa-aaaa-aaaa-000000000003', '10101010-1010-1010-1010-101010101001', 'Audio Set', 'Standard PA System (2 Wireless Mics + Speaker)', 300000, NULL);
-- 4. Projector (Large - thay cho Exclusive)
CALL Amenity_Insert('aaaa1111-aaaa-aaaa-aaaa-000000000004', '10101010-1010-1010-1010-101010101001', 'Projector', 'P3 LED Video Wall (Custom Size)', 2000000, 'Large');
-- 5. Catering (Large - thay cho Exclusive)
CALL Amenity_Insert('aaaa1111-aaaa-aaaa-aaaa-000000000005', '10101010-1010-1010-1010-101010101001', 'Catering', 'VIP Gala Dinner Set Menu', 600000, 'Large');

-- =============================================================================
-- LOCATION 2: Sunrise Annex (Phòng họp nhỏ/vừa - Small/Medium)
-- ID: 10101010-1010-1010-1010-101010101002
-- =============================================================================
CALL Amenity_Insert('aaaa2222-aaaa-aaaa-aaaa-000000000001', '10101010-1010-1010-1010-101010101002', 'Projector', 'Portable Mini Projector (3000 Lumens)', 150000, 'Small');
CALL Amenity_Insert('aaaa2222-aaaa-aaaa-aaaa-000000000002', '10101010-1010-1010-1010-101010101002', 'Catering', 'Basic Tea Break (Coffee/Tea + Cookies)', 80000, 'Small');
CALL Amenity_Insert('aaaa2222-aaaa-aaaa-aaaa-000000000003', '10101010-1010-1010-1010-101010101002', 'Audio Set', 'Standard PA System (2 Wireless Mics + Speaker)', 300000, NULL);
CALL Amenity_Insert('aaaa2222-aaaa-aaaa-aaaa-000000000004', '10101010-1010-1010-1010-101010101002', 'Projector', 'Standard HD Projector & 100" Screen', 300000, 'Medium');
CALL Amenity_Insert('aaaa2222-aaaa-aaaa-aaaa-000000000005', '10101010-1010-1010-1010-101010101002', 'Catering', 'Lunch Box & Drink Set', 150000, 'Medium');

-- =============================================================================
-- LOCATION 3: Grace Events Center (Tiệc cưới - Large)
-- ID: 20202020-2020-2020-2020-202020202001
-- =============================================================================
CALL Amenity_Insert('bbbb1111-bbbb-bbbb-bbbb-000000000001', '20202020-2020-2020-2020-202020202001', 'Projector', 'High-Lumen Laser Projector & 200" Screen', 800000, 'Large');
CALL Amenity_Insert('bbbb1111-bbbb-bbbb-bbbb-000000000002', '20202020-2020-2020-2020-202020202001', 'Catering', 'Full Buffet Service (Asian/Western)', 400000, 'Large');
CALL Amenity_Insert('bbbb1111-bbbb-bbbb-bbbb-000000000003', '20202020-2020-2020-2020-202020202001', 'Audio Set', 'Standard PA System (2 Wireless Mics + Speaker)', 300000, NULL);
CALL Amenity_Insert('bbbb1111-bbbb-bbbb-bbbb-000000000004', '20202020-2020-2020-2020-202020202001', 'Projector', 'P3 LED Video Wall (Custom Size)', 2000000, 'Large');
CALL Amenity_Insert('bbbb1111-bbbb-bbbb-bbbb-000000000005', '20202020-2020-2020-2020-202020202001', 'Catering', 'Premium Wedding Banquet Menu', 700000, 'Large');

-- =============================================================================
-- LOCATION 4: Grace Studio Rooms (Studio - Small/Medium)
-- ID: 20202020-2020-2020-2020-202020202002
-- =============================================================================
CALL Amenity_Insert('bbbb2222-bbbb-bbbb-bbbb-000000000001', '20202020-2020-2020-2020-202020202002', 'Projector', 'Portable Mini Projector (3000 Lumens)', 150000, 'Small');
CALL Amenity_Insert('bbbb2222-bbbb-bbbb-bbbb-000000000002', '20202020-2020-2020-2020-202020202002', 'Catering', 'Basic Tea Break (Coffee/Tea + Cookies)', 80000, 'Small');
CALL Amenity_Insert('bbbb2222-bbbb-bbbb-bbbb-000000000003', '20202020-2020-2020-2020-202020202002', 'Audio Set', 'Standard PA System (2 Wireless Mics + Speaker)', 300000, NULL);
CALL Amenity_Insert('bbbb2222-bbbb-bbbb-bbbb-000000000004', '20202020-2020-2020-2020-202020202002', 'Projector', 'Standard HD Projector & 100" Screen', 300000, 'Medium');
CALL Amenity_Insert('bbbb2222-bbbb-bbbb-bbbb-000000000005', '20202020-2020-2020-2020-202020202002', 'Catering', 'Finger Food Platter', 200000, 'Medium');

-- =============================================================================
-- LOCATION 5: Heidi Banquet Hall (Tiệc sang trọng - Large)
-- ID: 30303030-3030-3030-3030-303030303001
-- =============================================================================
CALL Amenity_Insert('cccc1111-cccc-cccc-cccc-000000000001', '30303030-3030-3030-3030-303030303001', 'Projector', 'High-Lumen Laser Projector & 200" Screen', 800000, 'Large');
CALL Amenity_Insert('cccc1111-cccc-cccc-cccc-000000000002', '30303030-3030-3030-3030-303030303001', 'Catering', 'Full Buffet Service (Asian/Western)', 400000, 'Large');
CALL Amenity_Insert('cccc1111-cccc-cccc-cccc-000000000003', '30303030-3030-3030-3030-303030303001', 'Audio Set', 'Standard PA System (2 Wireless Mics + Speaker)', 300000, NULL);
CALL Amenity_Insert('cccc1111-cccc-cccc-cccc-000000000004', '30303030-3030-3030-3030-303030303001', 'Projector', 'P3 LED Video Wall (Custom Size)', 2000000, 'Large');
CALL Amenity_Insert('cccc1111-cccc-cccc-cccc-000000000005', '30303030-3030-3030-3030-303030303001', 'Catering', 'Cocktail Reception Package', 500000, 'Large');

-- =============================================================================
-- LOCATION 6: Heidi Meeting Suites (Họp nhỏ - Small)
-- ID: 30303030-3030-3030-3030-303030303002
-- =============================================================================
CALL Amenity_Insert('cccc2222-cccc-cccc-cccc-000000000001', '30303030-3030-3030-3030-303030303002', 'Projector', 'Portable Mini Projector (3000 Lumens)', 150000, 'Small');
CALL Amenity_Insert('cccc2222-cccc-cccc-cccc-000000000002', '30303030-3030-3030-3030-303030303002', 'Catering', 'Basic Tea Break (Coffee/Tea + Cookies)', 80000, 'Small');
CALL Amenity_Insert('cccc2222-cccc-cccc-cccc-000000000003', '30303030-3030-3030-3030-303030303002', 'Audio Set', 'Standard PA System (2 Wireless Mics + Speaker)', 300000, NULL);
CALL Amenity_Insert('cccc2222-cccc-cccc-cccc-000000000004', '30303030-3030-3030-3030-303030303002', 'Projector', 'Interactive Smart Board', 250000, 'Small');
CALL Amenity_Insert('cccc2222-cccc-cccc-cccc-000000000005', '30303030-3030-3030-3030-303030303002', 'Catering', 'Sandwich & Juice Combo', 120000, 'Small');

-- =============================================================================
-- LOCATION 7: Ivan Rooftop Venue (Ngoài trời - Medium/Large)
-- ID: 40404040-4040-4040-4040-404040404001
-- =============================================================================
CALL Amenity_Insert('dddd1111-dddd-dddd-dddd-000000000001', '40404040-4040-4040-4040-404040404001', 'Projector', 'Standard HD Projector & 100" Screen', 300000, 'Medium');
CALL Amenity_Insert('dddd1111-dddd-dddd-dddd-000000000002', '40404040-4040-4040-4040-404040404001', 'Catering', 'Lunch Box & Drink Set', 150000, 'Medium');
CALL Amenity_Insert('dddd1111-dddd-dddd-dddd-000000000003', '40404040-4040-4040-4040-404040404001', 'Audio Set', 'Standard PA System (2 Wireless Mics + Speaker)', 300000, NULL);
CALL Amenity_Insert('dddd1111-dddd-dddd-dddd-000000000004', '40404040-4040-4040-4040-404040404001', 'Projector', 'High-Lumen Laser Projector & 200" Screen', 800000, 'Large');
CALL Amenity_Insert('dddd1111-dddd-dddd-dddd-000000000005', '40404040-4040-4040-4040-404040404001', 'Catering', 'BBQ Party Package', 450000, 'Large');

-- =============================================================================
-- LOCATION 8: Ivan Conference Rooms (Hội nghị - Medium)
-- ID: 40404040-4040-4040-4040-404040404002
-- =============================================================================
CALL Amenity_Insert('dddd2222-dddd-dddd-dddd-000000000001', '40404040-4040-4040-4040-404040404002', 'Projector', 'Standard HD Projector & 100" Screen', 300000, 'Medium');
CALL Amenity_Insert('dddd2222-dddd-dddd-dddd-000000000002', '40404040-4040-4040-4040-404040404002', 'Catering', 'Lunch Box & Drink Set', 150000, 'Medium');
CALL Amenity_Insert('dddd2222-dddd-dddd-dddd-000000000003', '40404040-4040-4040-4040-404040404002', 'Audio Set', 'Standard PA System (2 Wireless Mics + Speaker)', 300000, NULL);
CALL Amenity_Insert('dddd2222-dddd-dddd-dddd-000000000004', '40404040-4040-4040-4040-404040404002', 'Projector', 'Standard HD Projector & 100" Screen', 300000, 'Medium');
CALL Amenity_Insert('dddd2222-dddd-dddd-dddd-000000000005', '40404040-4040-4040-4040-404040404002', 'Catering', 'Premium Coffee Break', 180000, 'Medium');

-- =============================================================================
-- LOCATION 9: Judy Event Space (Triển lãm - Medium/Large)
-- ID: 50505050-5050-5050-5050-505050505001
-- =============================================================================
CALL Amenity_Insert('eeee1111-eeee-eeee-eeee-000000000001', '50505050-5050-5050-5050-505050505001', 'Projector', 'Standard HD Projector & 100" Screen', 300000, 'Medium');
CALL Amenity_Insert('eeee1111-eeee-eeee-eeee-000000000002', '50505050-5050-5050-5050-505050505001', 'Catering', 'Finger Food Platter', 250000, 'Medium');
CALL Amenity_Insert('eeee1111-eeee-eeee-eeee-000000000003', '50505050-5050-5050-5050-505050505001', 'Audio Set', 'Standard PA System (2 Wireless Mics + Speaker)', 300000, NULL);
CALL Amenity_Insert('eeee1111-eeee-eeee-eeee-000000000004', '50505050-5050-5050-5050-505050505001', 'Projector', 'High-Lumen Laser Projector & 200" Screen', 800000, 'Large');
CALL Amenity_Insert('eeee1111-eeee-eeee-eeee-000000000005', '50505050-5050-5050-5050-505050505001', 'Catering', 'Canapes & Wine Service', 550000, 'Large');

-- =============================================================================
-- LOCATION 10: Judy Workshop Hub (Workshop - Small)
-- ID: 50505050-5050-5050-5050-505050505002
-- =============================================================================
CALL Amenity_Insert('eeee2222-eeee-eeee-eeee-000000000001', '50505050-5050-5050-5050-505050505002', 'Projector', 'Portable Mini Projector (3000 Lumens)', 150000, 'Small');
CALL Amenity_Insert('eeee2222-eeee-eeee-eeee-000000000002', '50505050-5050-5050-5050-505050505002', 'Catering', 'Basic Tea Break (Coffee/Tea + Cookies)', 80000, 'Small');
CALL Amenity_Insert('eeee2222-eeee-eeee-eeee-000000000003', '50505050-5050-5050-5050-505050505002', 'Audio Set', 'Standard PA System (2 Wireless Mics + Speaker)', 300000, NULL);
CALL Amenity_Insert('eeee2222-eeee-eeee-eeee-000000000004', '50505050-5050-5050-5050-505050505002', 'Projector', 'Smart TV 65 Inch', 100000, 'Small');
CALL Amenity_Insert('eeee2222-eeee-eeee-eeee-000000000005', '50505050-5050-5050-5050-505050505002', 'Catering', 'DIY Drink Station', 100000, 'Small');