-- DISCOUNTS
INSERT INTO discounts (discount_id, name, percentage, maxDiscountPrice, minPrice, venueTypeId, membershipTier, startedAt, expiredAt)
VALUES
  -- General holiday discount for many tiers
  (UUID_TO_BIN('d4000001-0000-0000-0000-000000000001'),
   'Holiday Special',
   20,
   300.00,
   100.00,
   NULL,
   'SILVER,GOLD,PLATINUM',
   '2025-11-01 00:00:00',
   '2025-12-31 23:59:59'),

  -- Conference-specific promo (applies to venueType Conference Hall)
  (UUID_TO_BIN('d4000002-0000-0000-0000-000000000002'),
   'Conference Promo',
   15,
   200.00,
   150.00,
   UUID_TO_BIN('12121212-1212-1212-1212-121212121212'), -- Conference Hall type
   'GOLD,PLATINUM',
   '2025-10-01 00:00:00',
   '2025-11-30 23:59:59');
