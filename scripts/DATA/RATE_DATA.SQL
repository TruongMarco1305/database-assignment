-- RATES (only allowed if client completed a booking at that location and endHour < NOW())
INSERT INTO rates (client_id, location_id, stars, comment, created_at)
VALUES
  -- Alice rated Sunrise Conference Hall after completing booking
  (UUID_TO_BIN('11111111-1111-1111-1111-111111111111'),
   UUID_TO_BIN('10101010-1010-1010-1010-101010101001'),
   5,
   'Excellent AV and service.',
   '2025-11-13 09:00:00'),

  -- Bob rated Sunrise Annex after completing booking
  (UUID_TO_BIN('22222222-2222-2222-2222-222222222222'),
   UUID_TO_BIN('10101010-1010-1010-1010-101010101002'),
   4,
   'Good room, comfortable seating.',
   '2025-11-16 10:00:00');