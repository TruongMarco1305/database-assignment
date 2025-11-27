DELIMITER $$

DROP EVENT IF EXISTS Event_Handler$$

CREATE EVENT Event_Handler
ON SCHEDULE EVERY 1 MINUTE -- Chạy mỗi phút
DO
BEGIN
    -- BƯỚC 1: Xử lý đơn hàng (Order Processing)
    -- =========================================================================
    
    -- 1.1. Trả phòng ngay lập tức khi hết giờ
    -- (Để kết thúc tính tiền và cộng điểm cho khách ngay, không bắt khách chờ)
    UPDATE orders
    SET status = 'COMPLETED'
    WHERE status = 'CONFIRMED' 
      AND endHour < NOW();

    -- 1.2. Hủy đơn treo (Quá hạn thanh toán mà vẫn PENDING)
    UPDATE orders
    SET status = 'CANCELLED'
    WHERE status = 'PENDING' 
      AND expiredAt < NOW();
END$$

DELIMITER ;