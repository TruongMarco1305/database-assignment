INSERT INTO venue_images (image_id, location_id, venueName, locationImgURL)
VALUES
  (UUID_TO_BIN('12121212-0000-0000-0000-000000000001'), UUID_TO_BIN('10101010-1010-1010-1010-101010101001'), 'Main Hall',      'https://example.com/venue_images/sunrise_mainhall.jpg'),
  (UUID_TO_BIN('12121212-0000-0000-0000-000000000002'), UUID_TO_BIN('10101010-1010-1010-1010-101010101002'), 'Annex Room',     'https://example.com/venue_images/sunrise_annex.jpg'),
  (UUID_TO_BIN('12121212-0000-0000-0000-000000000003'), UUID_TO_BIN('20202020-2020-2020-2020-202020202001'), 'Grand Ballroom', 'https://example.com/venue_images/grace_ballroom.jpg'),
  (UUID_TO_BIN('12121212-0000-0000-0000-000000000004'), UUID_TO_BIN('20202020-2020-2020-2020-202020202002'), 'Studio A',       'https://example.com/venue_images/grace_studio_a.jpg'),
  (UUID_TO_BIN('12121212-0000-0000-0000-000000000005'), UUID_TO_BIN('30303030-3030-3030-3030-303030303001'), 'Banquet Main',   'https://example.com/venue_images/heidi_banquet_main.jpg'),
  (UUID_TO_BIN('12121212-0000-0000-0000-000000000006'), UUID_TO_BIN('30303030-3030-3030-3030-303030303002'), 'Suite 1',        'https://example.com/venue_images/heidi_suite1.jpg'),
  (UUID_TO_BIN('12121212-0000-0000-0000-000000000007'), UUID_TO_BIN('40404040-4040-4040-4040-404040404001'), 'Rooftop Deck',   'https://example.com/venue_images/ivan_rooftop.jpg'),
  (UUID_TO_BIN('12121212-0000-0000-0000-000000000008'), UUID_TO_BIN('40404040-4040-4040-4040-404040404002'), 'Conference B',   'https://example.com/venue_images/ivan_conf_b.jpg'),
  (UUID_TO_BIN('12121212-0000-0000-0000-000000000009'), UUID_TO_BIN('50505050-5050-5050-5050-505050505001'), 'Exhibit Hall',   'https://example.com/venue_images/judy_exhibit.jpg'),
  (UUID_TO_BIN('12121212-0000-0000-0000-00000000000a'), UUID_TO_BIN('50505050-5050-5050-5050-505050505002'), 'Workshop Room',  'https://example.com/venue_images/judy_workshop.jpg');
