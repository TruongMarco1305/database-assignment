-- client
DELIMITER $$

CREATE TRIGGER Update_MemberPoints
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    -- Chỉ cộng điểm khi trạng thái chuyển từ KHÁC sang 'COMPLETED'
    IF NEW.status = 'COMPLETED' AND OLD.status <> 'COMPLETED' THEN
        UPDATE clients
        SET membership_points = membership_points + NEW.points
        WHERE user_id = NEW.client_id;
    END IF;
END$$

DELIMITER ;

-- location
DELIMITER $$

CREATE TRIGGER Update_VenueActive
AFTER UPDATE ON locations
FOR EACH ROW
BEGIN
    -- Nếu Location bị chuyển sang Inactive
    IF NEW.isActive = 0 AND OLD.isActive = 1 THEN
        UPDATE venues
        SET isActive = 0
        WHERE location_id = NEW.location_id;
    END IF;
    
    -- (Tùy chọn) Nếu Location mở lại, có thể bạn KHÔNG muốn tự động mở lại tất cả phòng 
    -- (vì có thể phòng đó đang sửa chữa thật), nên chỉ cần xử lý chiều khóa đi là an toàn nhất.
END$$

DELIMITER ;

-- order
DELIMITER $$

CREATE TRIGGER Calc_TotalPrice_Points
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE v_pricePerHour DECIMAL(10,2);
    DECLARE v_hours INT;

    -- 1. Lấy giá phòng hiện tại
    SELECT pricePerHour INTO v_pricePerHour
    FROM venues 
    WHERE location_id = NEW.venue_loc_id AND name = NEW.venueName;

    -- 2. Tính số giờ (làm tròn lên nếu cần, ở đây dùng TIMESTAMPDIFF giờ chẵn)
    SET v_hours = TIMESTAMPDIFF(HOUR, NEW.startHour, NEW.endHour);
    IF v_hours <= 0 THEN SET v_hours = 1; END IF; -- Tối thiểu 1 giờ

    -- 3. Gán giá trị
    SET NEW.totalPrice = v_pricePerHour * v_hours;
    
    -- 4. Tự động tính điểm luôn (Ví dụ: 10.000 VND = 1 điểm)
    SET NEW.points = FLOOR(NEW.totalPrice / 10000);
END$$

DELIMITER ;

-- AMENITY
DELIMITER $$

-- Trường hợp 1: Khi Venue bị XÓA (DELETE)
CREATE TRIGGER Update_Amenity_DelVenue
BEFORE DELETE ON venues
FOR EACH ROW
BEGIN
    -- Cập nhật tất cả Amenities thuộc phòng này về kho
    UPDATE amenities
    SET 
        venueName = NULL, -- Gỡ khỏi phòng
        status = 'STORAGE',
        isActive = 1      -- Đảm bảo ở kho thì luôn sẵn sàng dùng
    WHERE location_id = OLD.location_id 
      AND venueName = OLD.name;
END$$

-- Trường hợp 2: Khi Venue bị KHÓA (UPDATE isActive = 0)
CREATE TRIGGER Update_Amenity_DeacVenue
AFTER UPDATE ON venues
FOR EACH ROW
BEGIN
    IF NEW.isActive = 0 AND OLD.isActive = 1 THEN
        UPDATE amenities
        SET 
            venueName = NULL,
            status = 'STORAGE',
            isActive = 1
        WHERE location_id = NEW.location_id 
          AND venueName = NEW.name;
    END IF;
END$$

DELIMITER ;

-- rate
DELIMITER $$

CREATE TRIGGER Insert_AvgRate
AFTER INSERT ON rates
FOR EACH ROW
BEGIN
    UPDATE locations
    SET avgRating = (
        SELECT IFNULL(AVG(stars), 0) 
        FROM rates 
        WHERE location_id = NEW.location_id
    )
    WHERE location_id = NEW.location_id;
END$$

CREATE TRIGGER Update_AvgRate
AFTER UPDATE ON rates
FOR EACH ROW
BEGIN
    UPDATE locations
    SET avgRating = (
        SELECT IFNULL(AVG(stars), 0) 
        FROM rates 
        WHERE location_id = NEW.location_id
    )
    WHERE location_id = NEW.location_id;
END$$

CREATE TRIGGER Delete_AvgRate
AFTER DELETE ON rates
FOR EACH ROW
BEGIN
    UPDATE locations
    SET avgRating = (
        SELECT IFNULL(AVG(stars), 0) 
        FROM rates 
        WHERE location_id = NEW.location_id
    )
    WHERE location_id = NEW.location_id;
END$$

DELIMITER ;