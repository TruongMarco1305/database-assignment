-- client
DELIMITER $$
CREATE TRIGGER Update_OrderStatus
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    -- =================================================================
    -- TRƯỜNG HỢP 1: ĐƠN HÀNG BỊ HỦY (CANCELLED)
    -- Hành động: Dọn dẹp dữ liệu liên quan
    -- =================================================================
    IF NEW.status = 'CANCELLED' AND OLD.status != 'CANCELLED' THEN
        
        -- 1. Tháo gỡ tiện nghi (Amenities)
        -- Lưu ý: Việc delete này sẽ kích hoạt Trigger 'trg_OrderAmenity_Delete_UpdateOrder'
        -- Trigger đó sẽ tự động set Amenities.isActive = 1 (Trả về kho)
        DELETE FROM order_amenities 
        WHERE order_id = NEW.order_id;

        -- 2. Tháo gỡ mã giảm giá (Discounts)
        DELETE FROM applies 
        WHERE order_id = NEW.order_id;
        
    END IF;
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