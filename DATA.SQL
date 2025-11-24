-- 1.1 Tạo 5 Users cho Owners
INSERT INTO users (id, email, password, firstName, lastName, phoneNo, DoB) VALUES
('u_owner_01', 'owner1@business.com', 'pass123', 'Nguyen', 'Van A', '0901000001', '1990-01-01'),
('u_owner_02', 'owner2@business.com', 'pass123', 'Tran', 'Thi B', '0901000002', '1992-05-15'),
('u_owner_03', 'owner3@business.com', 'pass123', 'Le', 'Van C', '0901000003', '1988-11-20'),
('u_owner_04', 'owner4@business.com', 'pass123', 'Pham', 'Thi D', '0901000004', '1995-03-10'),
('u_owner_05', 'owner5@business.com', 'pass123', 'Hoang', 'Van E', '0901000005', '1985-08-30');

-- 1.2 Insert vào bảng Owners
INSERT INTO owners (user_id, bankId, bankName, accountName, accountNo) VALUES
('u_owner_01', 'VCB', 'Vietcombank', 'NGUYEN VAN A', '0011001'),
('u_owner_02', 'TCB', 'Techcombank', 'TRAN THI B', '0011002'),
('u_owner_03', 'MB', 'MB Bank', 'LE VAN C', '0011003'),
('u_owner_04', 'ACB', 'Asia Commercial Bank', 'PHAM THI D', '0011004'),
('u_owner_05', 'BIDV', 'BIDV', 'HOANG VAN E', '0011005');

-- 1.3 Tạo 10 Users cho Clients
INSERT INTO users (id, email, password, firstName, lastName, phoneNo, DoB) VALUES
('u_client_01', 'client1@gmail.com', 'pass123', 'Khach', 'Mot', '0912000001', '2000-01-01'),
('u_client_02', 'client2@gmail.com', 'pass123', 'Khach', 'Hai', '0912000002', '2001-02-02'),
('u_client_03', 'client3@gmail.com', 'pass123', 'Khach', 'Ba', '0912000003', '2002-03-03'),
('u_client_04', 'client4@gmail.com', 'pass123', 'Khach', 'Bon', '0912000004', '2003-04-04'),
('u_client_05', 'client5@gmail.com', 'pass123', 'Khach', 'Nam', '0912000005', '2004-05-05'),
('u_client_06', 'client6@gmail.com', 'pass123', 'Khach', 'Sau', '0912000006', '1999-06-06'),
('u_client_07', 'client7@gmail.com', 'pass123', 'Khach', 'Bay', '0912000007', '1998-07-07'),
('u_client_08', 'client8@gmail.com', 'pass123', 'Khach', 'Tam', '0912000008', '1997-08-08'),
('u_client_09', 'client9@gmail.com', 'pass123', 'Khach', 'Chin', '0912000009', '1996-09-09'),
('u_client_10', 'client10@gmail.com', 'pass123', 'Khach', 'Muoi', '0912000010', '1995-10-10');

-- 1.4 Insert vào bảng Clients
INSERT INTO clients (user_id, slug, membership_points, membership_tier) VALUES
('u_client_01', 'user-001', 10, 'BRONZE'),
('u_client_02', 'user-002', 50, 'BRONZE'),
('u_client_03', 'user-003', 100, 'SILVER'),
('u_client_04', 'user-004', 200, 'SILVER'),
('u_client_05', 'user-005', 500, 'GOLD'),
('u_client_06', 'user-006', 0, 'BRONZE'),
('u_client_07', 'user-007', 20, 'BRONZE'),
('u_client_08', 'user-008', 1200, 'PLATINUM'),
('u_client_09', 'user-009', 30, 'BRONZE'),
('u_client_10', 'user-010', 45, 'BRONZE');

-- venue_type
INSERT INTO venue_types (venueType_id, name, description, pricePerHour, capacity, area) VALUES
('vt_meeting', 'Meeting Room', 'Phòng họp tiêu chuẩn, cách âm tốt', 200000, 10, 25.0),
('vt_hall', 'Conference Hall', 'Sảnh hội nghị lớn, có sân khấu', 5000000, 200, 300.0),
('vt_studio', 'Photo Studio', 'Studio chụp ảnh với ánh sáng chuyên nghiệp', 500000, 5, 45.5),
('vt_wedding', 'Wedding Center', 'Trung tâm tiệc cưới sang trọng', 10000000, 500, 800.0),
('vt_cowork', 'Co-working Space', 'Không gian làm việc chung (Hot desk)', 50000, 1, 5.0);

-- location
INSERT INTO locations (location_id, owner_id, name, description, addrNo, ward, city, phoneNo, mapURL, thumbnailURL) VALUES
-- Owner 1
('loc_01', 'u_owner_01', 'The White Palace', 'Trung tâm hội nghị cao cấp', '100', 'P.1', 'TP.HCM', '0901000001', 'map.com/loc1', 'img.com/loc1.jpg'),
('loc_02', 'u_owner_01', 'Minimalist Studio', 'Studio phong cách tối giản', '12', 'P.2', 'TP.HCM', '0901000001', 'map.com/loc2', 'img.com/loc2.jpg'),

-- Owner 2
('loc_03', 'u_owner_02', 'Riverside Wedding', 'Tiệc cưới ven sông', '55', 'Thao Dien', 'TP.HCM', '0901000002', 'map.com/loc3', 'img.com/loc3.jpg'),
('loc_04', 'u_owner_02', 'Tech Hub Meeting', 'Phòng họp công nghệ cao', '88', 'P.Da Kao', 'TP.HCM', '0901000002', 'map.com/loc4', 'img.com/loc4.jpg'),

-- Owner 3
('loc_05', 'u_owner_03', 'Green Garden', 'Không gian xanh ngoài trời', '99', 'P.7', 'Ha Noi', '0901000003', 'map.com/loc5', 'img.com/loc5.jpg'),
('loc_06', 'u_owner_03', 'Old Quarter Hall', 'Sảnh tiệc phố cổ', '36', 'Hoan Kiem', 'Ha Noi', '0901000003', 'map.com/loc6', 'img.com/loc6.jpg'),

-- Owner 4
('loc_07', 'u_owner_04', 'Danang Beach Club', 'Sự kiện bãi biển', '1', 'My Khe', 'Da Nang', '0901000004', 'map.com/loc7', 'img.com/loc7.jpg'),
('loc_08', 'u_owner_04', 'Dragon Bridge Office', 'Văn phòng view cầu rồng', '2', 'Hai Chau', 'Da Nang', '0901000004', 'map.com/loc8', 'img.com/loc8.jpg'),

-- Owner 5
('loc_09', 'u_owner_05', 'Dalat Pine Hill', 'Sự kiện đồi thông', '10', 'P.3', 'Da Lat', '0901000005', 'map.com/loc9', 'img.com/loc9.jpg'),
('loc_10', 'u_owner_05', 'Cloud Hunting Homestay', 'Homestay kết hợp sự kiện', '20', 'Cau Dat', 'Da Lat', '0901000005', 'map.com/loc10', 'img.com/loc10.jpg');


-- venue
INSERT INTO venues (location_id, name, venueType_id, floor, isActive) VALUES
-- Location 1: The White Palace
('loc_01', 'Grand Hall A', 'vt_hall', '1', 1),
('loc_01', 'Grand Hall B', 'vt_hall', '1', 1),
('loc_01', 'VIP Room 1', 'vt_meeting', '2', 1),
('loc_01', 'VIP Room 2', 'vt_meeting', '2', 1),
('loc_01', 'Garden Zone', 'vt_wedding', 'G', 1),

-- Location 2: Minimalist Studio
('loc_02', 'Studio 1', 'vt_studio', '1', 1),
('loc_02', 'Studio 2', 'vt_studio', '1', 1),
('loc_02', 'Editing Room', 'vt_cowork', '2', 1),
('loc_02', 'Makeup Room', 'vt_meeting', '2', 1),
('loc_02', 'Lobby Area', 'vt_cowork', 'G', 1),

-- Location 3: Riverside Wedding
('loc_03', 'River View A', 'vt_wedding', 'G', 1),
('loc_03', 'River View B', 'vt_wedding', 'G', 1),
('loc_03', 'Sunset Deck', 'vt_studio', NULL, 1), -- Giả sử vt_party chưa tạo thì dùng null nếu fk check kĩ, nhưng ở trên chưa tạo vt_party, thay bằng vt_hall
('loc_03', 'Indoor Hall', 'vt_hall', '1', 1),
('loc_03', 'Bridal Room', 'vt_meeting', '2', 1),

-- Location 4: Tech Hub Meeting
('loc_04', 'Meeting Room 101', 'vt_meeting', '1', 1),
('loc_04', 'Meeting Room 102', 'vt_meeting', '1', 1),
('loc_04', 'Conference Room', 'vt_hall', '2', 1),
('loc_04', 'Open Desk A', 'vt_cowork', '3', 1),
('loc_04', 'Open Desk B', 'vt_cowork', '3', 1),

-- Location 5: Green Garden (Hà Nội)
('loc_05', 'Rose Garden', 'vt_wedding', 'G', 1),
('loc_05', 'Lotus Pond', 'vt_wedding', 'G', 1),
('loc_05', 'Tea Room', 'vt_meeting', '1', 1),
('loc_05', 'Bamboo Hut', 'vt_studio', 'G', 1),
('loc_05', 'Main House', 'vt_hall', '1', 1),

-- Location 6: Old Quarter Hall
('loc_06', 'Hanoi Suite', 'vt_meeting', '2', 1),
('loc_06', 'Indochine Hall', 'vt_hall', '1', 1),
('loc_06', 'Rooftop Bar', 'vt_cowork', 'R', 1),
('loc_06', 'Private Dining', 'vt_meeting', '2', 1),
('loc_06', 'Balcony Seat', 'vt_cowork', '3', 1),

-- Location 7: Danang Beach Club
('loc_07', 'Beach Front', 'vt_wedding', 'G', 1),
('loc_07', 'Pool Side', 'vt_wedding', 'G', 1),
('loc_07', 'Ocean View Room', 'vt_meeting', '1', 1),
('loc_07', 'Surfing Bar', 'vt_cowork', 'G', 1),
('loc_07', 'Event Tent', 'vt_hall', 'G', 1),

-- Location 8: Dragon Bridge Office
('loc_08', 'Board Room', 'vt_meeting', '10', 1),
('loc_08', 'Training Room', 'vt_hall', '10', 1),
('loc_08', 'Hot Desk 1', 'vt_cowork', '11', 1),
('loc_08', 'Hot Desk 2', 'vt_cowork', '11', 1),
('loc_08', 'Interview Room', 'vt_meeting', '11', 1),

-- Location 9: Dalat Pine Hill
('loc_09', 'Forest Stage', 'vt_hall', 'G', 1),
('loc_09', 'Camping Zone 1', 'vt_cowork', 'G', 1),
('loc_09', 'Camping Zone 2', 'vt_cowork', 'G', 1),
('loc_09', 'Wood Cabin', 'vt_studio', '1', 1),
('loc_09', 'Fireplace Room', 'vt_meeting', '1', 1),

-- Location 10: Cloud Hunting Homestay
('loc_10', 'Cloud Deck', 'vt_studio', 'R', 1),
('loc_10', 'Sunrise Spot', 'vt_studio', 'R', 1),
('loc_10', 'Attic Room', 'vt_cowork', '3', 1),
('loc_10', 'Garden BBQ', 'vt_hall', 'G', 1),
('loc_10', 'Family Room', 'vt_meeting', '1', 1);

-- rating
-- =============================================
-- KHÁCH HÀNG 1 (u_client_01) ĐÁNH GIÁ 10 ĐỊA ĐIỂM
-- =============================================
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_01', 'loc_01', 5, 'Dịch vụ tuyệt vời, sẽ quay lại!');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_01', 'loc_02', 4, 'Studio đẹp nhưng hơi xa trung tâm.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_01', 'loc_03', 5, 'Không gian ven sông cực kỳ thoáng mát.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_01', 'loc_04', 3, 'Phòng họp ổn nhưng wifi đôi lúc chập chờn.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_01', 'loc_05', 4, 'Sân vườn rộng rãi, rất thích hợp tiệc ngoài trời.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_01', 'loc_06', 5, 'Kiến trúc cổ kính rất ấn tượng.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_01', 'loc_07', 5, 'Bãi biển sạch, nhân viên nhiệt tình.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_01', 'loc_08', 4, 'View cầu rồng đẹp, văn phòng hiện đại.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_01', 'loc_09', 2, 'Đường đi khó tìm, buổi tối hơi vắng.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_01', 'loc_10', 5, 'Săn mây buổi sáng là trải nghiệm không thể quên.');

-- =============================================
-- KHÁCH HÀNG 2 (u_client_02) ĐÁNH GIÁ 10 ĐỊA ĐIỂM
-- =============================================
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_02', 'loc_01', 4, 'Sảnh tiệc sang trọng, âm thanh tốt.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_02', 'loc_02', 5, 'Ánh sáng studio rất chuyên nghiệp.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_02', 'loc_03', 4, 'Đồ ăn ngon, phục vụ chu đáo.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_02', 'loc_04', 4, 'Thiết bị họp hiện đại, dễ kết nối.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_02', 'loc_05', 3, 'Nhiều muỗi vào buổi tối, cần khắc phục.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_02', 'loc_06', 5, 'Không gian ấm cúng, decor đẹp.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_02', 'loc_07', 5, 'Team building ở đây rất vui.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_02', 'loc_08', 4, 'Vị trí thuận tiện đi lại.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_02', 'loc_09', 5, 'Không khí Đà Lạt tuyệt vời.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_02', 'loc_10', 4, 'Homestay dễ thương, chủ nhà thân thiện.');

-- =============================================
-- KHÁCH HÀNG 3 (u_client_03) ĐÁNH GIÁ 10 ĐỊA ĐIỂM
-- =============================================
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_03', 'loc_01', 3, 'Giá hơi cao so với mặt bằng chung.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_03', 'loc_02', 4, 'Phong cách tối giản rất hợp gu mình.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_03', 'loc_03', 5, 'Hoàng hôn ở đây đẹp xuất sắc.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_03', 'loc_04', 4, 'Ghế ngồi thoải mái, làm việc lâu không mỏi.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_03', 'loc_05', 5, 'Cây xanh nhiều, không khí trong lành.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_03', 'loc_06', 4, 'Vị trí trung tâm phố cổ rất tiện.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_03', 'loc_07', 4, 'Gió biển mát rượi, đồ uống ngon.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_03', 'loc_08', 5, 'Văn phòng xịn xò, view triệu đô.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_03', 'loc_09', 3, 'Phòng cách âm chưa tốt lắm.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_03', 'loc_10', 5, 'Sáng sớm mở cửa ra là thấy mây bay.');

-- =============================================
-- KHÁCH HÀNG 4 (u_client_04) ĐÁNH GIÁ 10 ĐỊA ĐIỂM
-- =============================================
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_04', 'loc_01', 5, 'Chuyên nghiệp từ khâu gửi xe.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_04', 'loc_02', 3, 'Diện tích hơi nhỏ so với ảnh chụp.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_04', 'loc_03', 5, 'Địa điểm cưới trong mơ.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_04', 'loc_04', 4, 'Phòng sạch sẽ, thơm tho.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_04', 'loc_05', 4, 'Rất chill, thích hợp tụ tập bạn bè.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_04', 'loc_06', 5, 'Món ăn đậm chất Hà Nội.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_04', 'loc_07', 3, 'Hơi đông đúc vào cuối tuần.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_04', 'loc_08', 4, 'Không gian làm việc yên tĩnh.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_04', 'loc_09', 5, 'Rừng thông đẹp như phim.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_04', 'loc_10', 4, 'Tiệc nướng BBQ buổi tối rất vui.');

-- =============================================
-- KHÁCH HÀNG 5 (u_client_05) ĐÁNH GIÁ 10 ĐỊA ĐIỂM
-- =============================================
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_05', 'loc_01', 4, 'Sảnh chờ rộng, nhân viên lịch sự.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_05', 'loc_02', 5, 'Concept chụp ảnh đa dạng.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_05', 'loc_03', 4, 'Trang trí tiệc cưới rất tinh tế.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_05', 'loc_04', 5, 'Mạng internet tốc độ cao.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_05', 'loc_05', 4, 'Thoáng đãng, gần gũi thiên nhiên.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_05', 'loc_06', 3, 'Chỗ để xe hơi bất tiện.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_05', 'loc_07', 5, 'Biển xanh cát trắng nắng vàng.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_05', 'loc_08', 4, 'Tiện nghi văn phòng đầy đủ.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_05', 'loc_09', 5, 'Sẽ quay lại vào mùa đông.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_05', 'loc_10', 5, 'View đồi chè Cầu Đất siêu đẹp.');

-- =============================================
-- KHÁCH HÀNG 6 (u_client_06) ĐÁNH GIÁ 10 ĐỊA ĐIỂM
-- =============================================
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_06', 'loc_01', 5, 'Tổ chức sự kiện rất chuyên nghiệp.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_06', 'loc_02', 4, 'Giá cả hợp lý cho sinh viên.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_06', 'loc_03', 5, 'Không gian lãng mạn vô cùng.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_06', 'loc_04', 3, 'Điều hòa hơi lạnh.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_06', 'loc_05', 5, 'Rất thích hồ cá Koi ở đây.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_06', 'loc_06', 4, 'Nhân viên mặc áo dài rất đẹp.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_06', 'loc_07', 4, 'Hải sản tươi ngon.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_06', 'loc_08', 5, 'Văn phòng đáng mơ ước.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_06', 'loc_09', 4, 'Phòng ốc sạch sẽ, ấm cúng.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_06', 'loc_10', 3, 'Nước nóng hơi yếu.');

-- =============================================
-- KHÁCH HÀNG 7 (u_client_07) ĐÁNH GIÁ 10 ĐỊA ĐIỂM
-- =============================================
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_07', 'loc_01', 4, 'Hệ thống ánh sáng sân khấu tốt.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_07', 'loc_02', 5, 'Chụp lookbook ở đây bao đẹp.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_07', 'loc_03', 4, 'Bãi cỏ xanh mướt, rất đẹp.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_07', 'loc_04', 5, 'Book phòng nhanh chóng, tiện lợi.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_07', 'loc_05', 4, 'Không gian yên bình giữa lòng phố.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_07', 'loc_06', 5, 'Cảm giác như trở về Hà Nội xưa.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_07', 'loc_07', 5, 'Tuyệt vời cho kỳ nghỉ hè.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_07', 'loc_08', 4, 'Pantry có nhiều đồ ăn vặt.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_07', 'loc_09', 5, 'Thức dậy giữa rừng thông là cảm giác rất chill.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_07', 'loc_10', 4, 'Săn mây thành công, ảnh đẹp lung linh.');

-- =============================================
-- KHÁCH HÀNG 8 (u_client_08) ĐÁNH GIÁ 10 ĐỊA ĐIỂM
-- =============================================
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_08', 'loc_01', 5, 'Dịch vụ 5 sao chuẩn chỉnh.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_08', 'loc_02', 4, 'Nhân viên hỗ trợ setup nhiệt tình.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_08', 'loc_03', 5, 'View sông Sài Gòn về đêm cực đẹp.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_08', 'loc_04', 4, 'Phòng cách âm tốt, tập trung làm việc hiệu quả.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_08', 'loc_05', 3, 'Giá đồ uống hơi đắt.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_08', 'loc_06', 5, 'Sảnh tiệc lộng lẫy, sang trọng.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_08', 'loc_07', 4, 'Bãi biển riêng tư, sạch sẽ.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_08', 'loc_08', 5, 'Cơ sở vật chất hiện đại bậc nhất Đà Nẵng.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_08', 'loc_09', 4, 'Buổi tối nướng khoai bắp rất vui.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_08', 'loc_10', 5, 'Chắc chắn sẽ giới thiệu cho bạn bè.');

-- =============================================
-- KHÁCH HÀNG 9 (u_client_09) ĐÁNH GIÁ 10 ĐỊA ĐIỂM
-- =============================================
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_09', 'loc_01', 4, 'Giao thông khu vực này hơi kẹt xe giờ cao điểm.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_09', 'loc_02', 5, 'Thiết kế thông minh, tận dụng ánh sáng tốt.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_09', 'loc_03', 4, 'Nhân viên phục vụ hơi chậm khi đông khách.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_09', 'loc_04', 5, 'Rất hài lòng về dịch vụ.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_09', 'loc_05', 4, 'Không gian xanh mát, dễ chịu.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_09', 'loc_06', 5, 'Ẩm thực tinh tế, ngon miệng.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_09', 'loc_07', 5, 'Biển đẹp, cát trắng, nắng vàng.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_09', 'loc_08', 3, 'Thang máy tòa nhà hơi chậm.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_09', 'loc_09', 5, 'Không khí trong lành, yên tĩnh.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_09', 'loc_10', 4, 'Phòng ốp gỗ rất thơm.');

-- =============================================
-- KHÁCH HÀNG 10 (u_client_10) ĐÁNH GIÁ 10 ĐỊA ĐIỂM
-- =============================================
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_10', 'loc_01', 5, 'Không gian hội nghị đẳng cấp.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_10', 'loc_02', 4, 'Nhiều góc sống ảo đẹp.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_10', 'loc_03', 5, 'Tiệc cưới ngoài trời quá tuyệt.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_10', 'loc_04', 4, 'Bàn ghế ergonomic ngồi rất sướng.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_10', 'loc_05', 5, 'Địa điểm check-in không thể bỏ qua.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_10', 'loc_06', 4, 'Giá hơi chát nhưng xứng đáng.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_10', 'loc_07', 5, 'Resort ven biển tuyệt đẹp.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_10', 'loc_08', 5, 'View nhìn ra sông Hàn cực chill.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_10', 'loc_09', 4, 'Đường vào hơi dốc nhưng cảnh đẹp bù lại.');
INSERT INTO rates (client_id, location_id, stars, comment) VALUES ('u_client_10', 'loc_10', 5, 'Săn mây thành công mỹ mãn.');