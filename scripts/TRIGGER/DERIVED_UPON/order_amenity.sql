DELIMITER $$
CREATE TRIGGER Update_AmenityPrice_Points
AFTER INSERT ON order_amenities
FOR EACH ROW
BEGIN
    -- Cập nhật bảng ORDERS: Cộng thêm giá của tiện nghi vừa thêm
    UPDATE orders
    SET 
        totalPrice = totalPrice + NEW.price,
        points = FLOOR((totalPrice + NEW.price) / 10000) -- Tính lại điểm theo tổng tiền mới
    WHERE order_id = NEW.order_id;
    
    -- (Logic cũ: Khóa Amenity)
    UPDATE amenities SET isActive = 0 WHERE amenity_id = NEW.amenity_id;
END$$

DELIMITER ;

DELIMITER $$
CREATE TRIGGER Delete_AmenityPrice_Points
AFTER DELETE ON order_amenities
FOR EACH ROW
BEGIN
    -- Cập nhật bảng ORDERS: Trừ đi giá của tiện nghi vừa xóa
    UPDATE orders
    SET 
        totalPrice = totalPrice - OLD.price,
        points = FLOOR((totalPrice - OLD.price) / 10000)
    WHERE order_id = OLD.order_id;

    -- (Logic cũ: Mở khóa Amenity)
    UPDATE amenities SET isActive = 1 WHERE amenity_id = OLD.amenity_id;
END$$

DELIMITER ;