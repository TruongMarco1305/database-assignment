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

-- order - discount
DELIMITER $$
CREATE TRIGGER Calc_BasePrice_Points
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

-- amenity
DELIMITER $$
CREATE TRIGGER Update_Amenity_Completed
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    -- =================================================================
    -- PHẦN 1: QUẢN LÝ THIẾT BỊ (AMENITIES)
    -- =================================================================
    
    -- Nếu đơn hàng kết thúc (Hoàn thành hoặc Hủy) -> Mở khóa thiết bị
    IF NEW.status IN ('CANCELLED', 'COMPLETED') AND OLD.status NOT IN ('CANCELLED', 'COMPLETED') THEN
        
        -- Cập nhật tất cả thiết bị đi kèm đơn hàng này thành Active = 1
        UPDATE amenities a
        INNER JOIN order_amenities oa ON a.amenity_id = oa.amenity_id
        SET a.isActive = 1
        WHERE oa.order_id = NEW.order_id;
        
    END IF;
END$$

DELIMITER ;