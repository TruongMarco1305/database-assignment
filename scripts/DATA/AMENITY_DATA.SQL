INSERT INTO amenities (amenity_id, location_id, venueName, category, description) VALUES
  -- Main Hall (Sunrise Conference Hall)
  (UUID_TO_BIN('d1111111-1111-1111-1111-111111111001'), UUID_TO_BIN('10101010-1010-1010-1010-101010101001'), 'Main Hall',       'Audio/Visual',  'Full AV system with wireless microphones, PA, mixer and speakers.'),
  (UUID_TO_BIN('d2222222-2222-2222-2222-222222222002'), UUID_TO_BIN('10101010-1010-1010-1010-101010101001'), 'Main Hall',       'Stage',         'Large stage with backdrop and stage lighting.'),

  -- Annex Room (Sunrise Annex)
  (UUID_TO_BIN('d3333333-3333-3333-3333-333333333003'), UUID_TO_BIN('10101010-1010-1010-1010-101010101002'), 'Annex Room',      'Seating',       'Modular seating arrangement for 20–60 people.'),
  (UUID_TO_BIN('d4444444-4444-4444-4444-444444444004'), UUID_TO_BIN('10101010-1010-1010-1010-101010101002'), 'Annex Room',      'Whiteboard',    'Mobile whiteboards, markers and flip charts.'),

  -- Grand Ballroom (Grace Events Center)
  (UUID_TO_BIN('d5555555-5555-5555-5555-555555555005'), UUID_TO_BIN('20202020-2020-2020-2020-202020202001'), 'Grand Ballroom',  'Catering',      'In-house catering options with customizable menus.'),
  (UUID_TO_BIN('d6666666-6666-6666-6666-666666666006'), UUID_TO_BIN('20202020-2020-2020-2020-202020202001'), 'Grand Ballroom',  'Lighting',      'Professional lighting rig and dimmable house lights.'),

  -- Studio A (Grace Studio Rooms)
  (UUID_TO_BIN('d7777777-7777-7777-7777-777777777007'), UUID_TO_BIN('20202020-2020-2020-2020-202020202002'), 'Studio A',        'Soundproof',    'Soundproofed studio suitable for rehearsals and recordings.'),
  (UUID_TO_BIN('d8888888-8888-8888-8888-888888888008'), UUID_TO_BIN('20202020-2020-2020-2020-202020202002'), 'Studio A',        'Mirrors',       'Full-wall mirrors and barre for dance sessions.'),

  -- Banquet Main (Heidi Banquet Hall)
  (UUID_TO_BIN('d9999999-9999-9999-9999-999999999009'), UUID_TO_BIN('30303030-3030-3030-3030-303030303001'), 'Banquet Main',    'Decor',         'Decoration service and staging available upon request.'),
  (UUID_TO_BIN('daaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa00aa'), UUID_TO_BIN('30303030-3030-3030-3030-303030303001'), 'Banquet Main',    'Parking',       'On-site parking area with capacity for ~80 cars.'),

  -- Suite 1 (Heidi Meeting Suites)
  (UUID_TO_BIN('db111111-1111-1111-1111-111111111011'), UUID_TO_BIN('30303030-3030-3030-3030-303030303002'), 'Suite 1',         'Projector',     'HD projector with retractable screen.'),
  (UUID_TO_BIN('db222222-2222-2222-2222-222222222012'), UUID_TO_BIN('30303030-3030-3030-3030-303030303002'), 'Suite 1',         'Conference Phone','Conference phone system for remote calls.'),

  -- Rooftop Deck (Ivan Rooftop Venue)
  (UUID_TO_BIN('dc333333-3333-3333-3333-333333333013'), UUID_TO_BIN('40404040-4040-4040-4040-404040404001'), 'Rooftop Deck',    'Bar',           'Portable bar setup and bartender service available.'),
  (UUID_TO_BIN('dc444444-4444-4444-4444-444444444014'), UUID_TO_BIN('40404040-4040-4040-4040-404040404001'), 'Rooftop Deck',    'Outdoor Heaters','Heaters available for evening events (rental).'),

  -- Conference B (Ivan Conference Rooms)
  (UUID_TO_BIN('dd555555-5555-5555-5555-555555555015'), UUID_TO_BIN('40404040-4040-4040-4040-404040404002'), 'Conference B',    'Video Conferencing','Ready-to-use Zoom/Teams video conferencing setup.'),
  (UUID_TO_BIN('dd666666-6666-6666-6666-666666666016'), UUID_TO_BIN('40404040-4040-4040-4040-404040404002'), 'Conference B',    'Flipchart',     'Flipcharts, markers and stationery provided.'),

  -- Exhibit Hall (Judy Event Space)
  (UUID_TO_BIN('de777777-7777-7777-7777-777777777017'), UUID_TO_BIN('50505050-5050-5050-5050-505050505001'), 'Exhibit Hall',    'Exhibit Booths', 'Modular exhibit booths and power hookups available.'),
  (UUID_TO_BIN('de888888-8888-8888-8888-888888888018'), UUID_TO_BIN('50505050-5050-5050-5050-505050505001'), 'Exhibit Hall',    'Security',      'On-site security personnel available during events.'),

  -- Workshop Room (Judy Workshop Hub)
  (UUID_TO_BIN('df999999-9999-9999-9999-999999999019'), UUID_TO_BIN('50505050-5050-5050-5050-505050505002'), 'Workshop Room',   'WiFi',          'High-speed fiber internet with guest access.'),
  (UUID_TO_BIN('dfaaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa01aa'), UUID_TO_BIN('50505050-5050-5050-5050-505050505002'), 'Workshop Room',   'Tables',        'Foldable tables and stackable chairs; cleaning included.');
