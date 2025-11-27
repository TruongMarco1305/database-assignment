-- 10 users (5 clients, 5 owners)
INSERT INTO users (id, email, password, firstName, lastName, phoneNo, avatarURL, DoB)
VALUES
  (UUID_TO_BIN('11111111-1111-1111-1111-111111111111'), 'alice.smith@example.com', 'Password1!', 'Alice', 'Smith', '0900000001', 'https://example.com/avatars/alice.jpg', '1992-05-15'),
  (UUID_TO_BIN('22222222-2222-2222-2222-222222222222'), 'bob.jones@example.com', 'SecurePwd2',  'Bob',   'Jones', '0900000002', 'https://example.com/avatars/bob.jpg',   '1989-11-20'),
  (UUID_TO_BIN('33333333-3333-3333-3333-333333333333'), 'carol.wilson@example.com','TopSecret3','Carol', 'Wilson','0900000003','https://example.com/avatars/carol.jpg','1990-03-02'),
  (UUID_TO_BIN('44444444-4444-4444-4444-444444444444'), 'david.lee@example.com',    'MyPassw0rd',  'David', 'Lee',   '0900000004','https://example.com/avatars/david.jpg','1987-07-08'),
  (UUID_TO_BIN('55555555-5555-5555-5555-555555555555'), 'eve.adams@example.com',    'EveStrong9',  'Eve',   'Adams', '0900000005','https://example.com/avatars/eve.jpg','1993-12-01'),

  (UUID_TO_BIN('66666666-6666-6666-6666-666666666666'), 'frank.ho@example.com',    'OwnerPwd01',  'Frank', 'Ho',    '0900000101','https://example.com/avatars/frank.jpg','1985-02-14'),
  (UUID_TO_BIN('77777777-7777-7777-7777-777777777777'), 'grace.lam@example.com',   'OwnerPwd02',  'Grace', 'Lam',   '0900000102','https://example.com/avatars/grace.jpg','1986-09-09'),
  (UUID_TO_BIN('88888888-8888-8888-8888-888888888888'), 'heidi.kim@example.com',   'OwnerPwd03',  'Heidi', 'Kim',   '0900000103','https://example.com/avatars/heidi.jpg','1984-04-20'),
  (UUID_TO_BIN('99999999-9999-9999-9999-999999999999'), 'ivan.tran@example.com',   'OwnerPwd04',  'Ivan',  'Tran',  '0900000104','https://example.com/avatars/ivan.jpg','1982-10-30'),
  (UUID_TO_BIN('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'), 'judy.nguyen@example.com', 'OwnerPwd05',  'Judy',  'Nguyen','0900000105','https://example.com/avatars/judy.jpg','1979-06-05');

-- Insert 5 clients (linking to first 5 user ids)
INSERT INTO clients (user_id, slug, membership_points)
VALUES
  (UUID_TO_BIN('11111111-1111-1111-1111-111111111111'), 'alice', 1200),
  (UUID_TO_BIN('22222222-2222-2222-2222-222222222222'), 'bobj',  350),
  (UUID_TO_BIN('33333333-3333-3333-3333-333333333333'), 'carolw', 5200),
  (UUID_TO_BIN('44444444-4444-4444-4444-444444444444'), 'davidl', 750),
  (UUID_TO_BIN('55555555-5555-5555-5555-555555555555'), 'evea',   50);

-- Insert 5 owners (linking to last 5 user ids)
INSERT INTO owners (user_id, bankId, bankName, accountName, accountNo)
VALUES
  (UUID_TO_BIN('66666666-6666-6666-6666-666666666666'), 'VCB', 'Vietcombank', 'Frank Ho',  '012345678901'),
  (UUID_TO_BIN('77777777-7777-7777-7777-777777777777'), 'BIDV','BIDV Bank',   'Grace Lam', '112233445566'),
  (UUID_TO_BIN('88888888-8888-8888-8888-888888888888'), 'ACB', 'ACB Bank',    'Heidi Kim', '223344556677'),
  (UUID_TO_BIN('99999999-9999-9999-9999-999999999999'), 'TCB', 'TPBank',      'Ivan Tran', '334455667788'),
  (UUID_TO_BIN('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'), 'MB',  'MB Bank',     'Judy Nguyen','445566778899');
