-- INVOICES
INSERT INTO invoices (invoice_id, order_id, amount, paidOn)
VALUES
  -- Invoice for Alice's order (order a1...a1)
  (UUID_TO_BIN('b5000000-0000-0000-0000-0000000000b1'),
   UUID_TO_BIN('a1000000-0000-0000-0000-0000000000a1'),
   450.00,
   '2025-11-12 14:00:00'),

  -- Invoice for Bob's order (order a1...a2)
  (UUID_TO_BIN('b5000000-0000-0000-0000-0000000000b2'),
   UUID_TO_BIN('a1000000-0000-0000-0000-0000000000a2'),
   120.00,
   '2025-11-15 12:15:00'),

  -- Invoice for David's order (order a1...a4) — unpaid (paidOn NULL)
  (UUID_TO_BIN('b5000000-0000-0000-0000-0000000000b3'),
   UUID_TO_BIN('a1000000-0000-0000-0000-0000000000a4'),
   360.00,
   NULL);
