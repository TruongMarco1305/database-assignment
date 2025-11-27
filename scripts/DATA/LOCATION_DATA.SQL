-- Locations for Frank Ho (owner user_id = '66666666-6666-6666-6666-666666666666')
INSERT INTO locations (location_id, owner_id, name, description, addrNo, ward, city, policy, phoneNo, mapURL, thumbnailURL)
VALUES
  (UUID_TO_BIN('10101010-1010-1010-1010-101010101001'),
   UUID_TO_BIN('66666666-6666-6666-6666-666666666666'),
   'Sunrise Conference Hall',
   'Spacious conference hall with AV system and stage. Capacity up to 200.',
   '12A', 'Ward 1', 'Ho Chi Minh City',
   'No smoking. No outside catering without permission.',
   '0901234001',
   'https://maps.example.com/?q=Sunrise+Conference+Hall',
   'https://example.com/thumbs/sunrise_hall.jpg'),

  (UUID_TO_BIN('10101010-1010-1010-1010-101010101002'),
   UUID_TO_BIN('66666666-6666-6666-6666-666666666666'),
   'Sunrise Annex',
   'Smaller meeting rooms and breakout spaces adjacent to the main hall.',
   '14B', 'Ward 1', 'Ho Chi Minh City',
   'Equipment rental extra. Booking deposit required.',
   '0901234002',
   'https://maps.example.com/?q=Sunrise+Annex',
   'https://example.com/thumbs/sunrise_annex.jpg');

-- Locations for Grace Lam (owner user_id = '77777777-7777-7777-7777-777777777777')
INSERT INTO locations (location_id, owner_id, name, description, addrNo, ward, city, policy, phoneNo, mapURL, thumbnailURL)
VALUES
  (UUID_TO_BIN('20202020-2020-2020-2020-202020202001'),
   UUID_TO_BIN('77777777-7777-7777-7777-777777777777'),
   'Grace Events Center',
   'Modern events center suitable for weddings, conferences and banquets.',
   '88', 'Ward 5', 'Hanoi',
   'Cancellations within 7 days are non-refundable.',
   '0901234101',
   'https://maps.example.com/?q=Grace+Events+Center',
   'https://example.com/thumbs/grace_events.jpg'),

  (UUID_TO_BIN('20202020-2020-2020-2020-202020202002'),
   UUID_TO_BIN('77777777-7777-7777-7777-777777777777'),
   'Grace Studio Rooms',
   'Flexible studio rooms for workshops and small classes (20–40 pax).',
   '90', 'Ward 5', 'Hanoi',
   'Please respect quiet hours after 22:00.',
   '0901234102',
   'https://maps.example.com/?q=Grace+Studio+Rooms',
   'https://example.com/thumbs/grace_studio.jpg');

-- Locations for Heidi Kim (owner user_id = '88888888-8888-8888-8888-888888888888')
INSERT INTO locations (location_id, owner_id, name, description, addrNo, ward, city, policy, phoneNo, mapURL, thumbnailURL)
VALUES
  (UUID_TO_BIN('30303030-3030-3030-3030-303030303001'),
   UUID_TO_BIN('88888888-8888-8888-8888-888888888888'),
   'Heidi Banquet Hall',
   'Elegant banquet hall with in-house catering options and decoration services.',
   '5', 'Ward 2', 'Da Nang',
   'Decoration allowed 4 hours prior; extra fees may apply.',
   '0901234201',
   'https://maps.example.com/?q=Heidi+Banquet+Hall',
   'https://example.com/thumbs/heidi_banquet.jpg'),

  (UUID_TO_BIN('30303030-3030-3030-3030-303030303002'),
   UUID_TO_BIN('88888888-8888-8888-8888-888888888888'),
   'Heidi Meeting Suites',
   'Compact meeting suites with whiteboards and high-speed internet.',
   '7', 'Ward 2', 'Da Nang',
   'Free Wi-Fi included; refunds subject to policy.',
   '0901234202',
   'https://maps.example.com/?q=Heidi+Meeting+Suites',
   'https://example.com/thumbs/heidi_suites.jpg');

-- Locations for Ivan Tran (owner user_id = '99999999-9999-9999-9999-999999999999')
INSERT INTO locations (location_id, owner_id, name, description, addrNo, ward, city, policy, phoneNo, mapURL, thumbnailURL)
VALUES
  (UUID_TO_BIN('40404040-4040-4040-4040-404040404001'),
   UUID_TO_BIN('99999999-9999-9999-9999-999999999999'),
   'Ivan Rooftop Venue',
   'Open-air rooftop venue perfect for evening events and parties.',
   '22', 'Ward 10', 'Ho Chi Minh City',
   'Outdoor events subject to weather; backup indoors recommended.',
   '0901234301',
   'https://maps.example.com/?q=Ivan+Rooftop+Venue',
   'https://example.com/thumbs/ivan_rooftop.jpg'),

  (UUID_TO_BIN('40404040-4040-4040-4040-404040404002'),
   UUID_TO_BIN('99999999-9999-9999-9999-999999999999'),
   'Ivan Conference Rooms',
   'Air-conditioned conference rooms with projector and seating for 50–120.',
   '24', 'Ward 10', 'Ho Chi Minh City',
   'Projector included; drinks allowed in designated areas.',
   '0901234302',
   'https://maps.example.com/?q=Ivan+Conference+Rooms',
   'https://example.com/thumbs/ivan_conference.jpg');

-- Locations for Judy Nguyen (owner user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa')
INSERT INTO locations (location_id, owner_id, name, description, addrNo, ward, city, policy, phoneNo, mapURL, thumbnailURL)
VALUES
  (UUID_TO_BIN('50505050-5050-5050-5050-505050505001'),
   UUID_TO_BIN('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
   'Judy Event Space',
   'Bright, contemporary event space good for exhibitions and pop-ups.',
   '3C', 'Ward 7', 'Hanoi',
   'No open flames. Security deposit required for exhibitions.',
   '0901234401',
   'https://maps.example.com/?q=Judy+Event+Space',
   'https://example.com/thumbs/judy_space.jpg'),

  (UUID_TO_BIN('50505050-5050-5050-5050-505050505002'),
   UUID_TO_BIN('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
   'Judy Workshop Hub',
   'Cozy hub for creative workshops and small seminars (10–30 pax).',
   '3D', 'Ward 7', 'Hanoi',
   'Please clean up after use; overtime charged per hour.',
   '0901234402',
   'https://maps.example.com/?q=Judy+Workshop+Hub',
   'https://example.com/thumbs/judy_workshop.jpg');
