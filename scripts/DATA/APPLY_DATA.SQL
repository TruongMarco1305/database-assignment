-- APPLIES (attach discount to orders)
-- Apply Conference Promo to Alice's completed order (order createdAt falls into discount window; Alice's tier qualifies)
INSERT INTO applies (order_id, discount_id)
VALUES
  (UUID_TO_BIN('a1000000-0000-0000-0000-000000000001'), UUID_TO_BIN('d4000002-0000-0000-0000-000000000002'));