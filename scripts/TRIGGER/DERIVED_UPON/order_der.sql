-- client
DELIMITER $$
CREATE TRIGGER Update_OrderCompleted
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    -- =================================================================
    -- PHẦN 1: GIẢI PHÓNG TÀI NGUYÊN (AMENITIES & VENUE)
    -- Chạy khi đơn hàng kết thúc (Dù là Hoàn thành hay Hủy)
    -- =================================================================
    -- IF NEW.status IN ('COMPLETED', 'CANCELLED') AND OLD.status NOT IN ('COMPLETED', 'CANCELLED') THEN
        
    --     -- 1.1. Trả Amenities về trạng thái sẵn sàng (isActive = 1)
    --     UPDATE amenities a
    --     INNER JOIN order_amenities oa ON a.amenity_id = oa.amenity_id
    --     SET a.isActive = 1
    --     WHERE oa.order_id = NEW.order_id;

    --     -- 1.2. Trả Venue về trạng thái sẵn sàng (isActive = 1)
    --     -- (Lưu ý: Chỉ cần thiết nếu quy trình của bạn có bước set isActive=0 khi đặt phòng)
    --     UPDATE venues
    --     SET isActive = 1
    --     WHERE location_id = NEW.venue_loc_id 
    --       AND name = NEW.venueName;
          
    -- END IF;

    -- =================================================================
    -- PHẦN 2: TÍCH ĐIỂM THÀNH VIÊN
    -- Chỉ chạy khi đơn hàng HOÀN TẤT (COMPLETED)
    -- =================================================================
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