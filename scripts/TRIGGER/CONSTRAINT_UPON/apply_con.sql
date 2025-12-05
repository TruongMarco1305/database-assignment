-- apply
DELIMITER $$
CREATE TRIGGER Check_ApplyDiscount
BEFORE INSERT ON applies
FOR EACH ROW
BEGIN
    -- Khai báo biến để lưu thông tin Discount
    DECLARE v_minPrice DECIMAL(12,2);
    DECLARE v_start DATETIME;
    DECLARE v_end DATETIME;
    DECLARE v_venueTypeId BINARY(16);
    DECLARE v_requiredTier VARCHAR(20);    
    -- Khai báo biến để lưu thông tin Order & Client
    DECLARE v_orderTotal DECIMAL(12,2);
    DECLARE v_bookingDate DATETIME;
    DECLARE v_orderVenueType BINARY(16);
    DECLARE v_clientPoints INT;
    DECLARE v_clientTier VARCHAR(20); -- SỬA: Đặt tên thống nhất là v_clientTier

    -- 1. Lấy thông tin Mã giảm giá
    SELECT minPrice, startedAt, expiredAt, venueTypeId, membershipTier
    INTO v_minPrice, v_start, v_end, v_venueTypeId, v_tiers
    FROM discounts WHERE discount_id = NEW.discount_id;

    -- 2. Lấy thông tin Đơn hàng & Điểm của khách
    SELECT o.totalPrice, o.createdAt, v.venueType_id, c.membership_points
    INTO v_orderTotal, v_bookingDate, v_orderVenueType, v_clientPoints
    FROM orders o
    JOIN venues v ON o.venue_loc_id = v.location_id AND o.venueName = v.name
    JOIN clients c ON o.client_id = c.user_id
    WHERE o.order_id = NEW.order_id;

    -- 3. Tính hạng thành viên ngay lập tức (Dynamic Calculation)
    -- Lưu ý: Đảm bảo bạn đã tạo function tên là 'Get_Tier' trong database
    SET v_clientTier = Get_Tier(v_clientPoints);

    -- 4. Bắt đầu kiểm tra
    -- Check 1: Thời gian hiệu lực (So với ngày tạo đơn)
    IF v_bookingDate < v_start OR v_bookingDate > v_end THEN
        SIGNAL SQLSTATE '45072' SET MESSAGE_TEXT = 'Error: Discount code is expired or not yet active.';
    END IF;

    -- Check 2: Đơn hàng tối thiểu
    IF v_minPrice IS NOT NULL AND v_orderTotal < v_minPrice THEN
        SIGNAL SQLSTATE '45073' SET MESSAGE_TEXT = 'Error: Order amount does not meet the minimum requirement for this discount.';
    END IF;

    -- Check 3: Loại phòng (Nếu discount có quy định)
    IF v_venueTypeId IS NOT NULL AND v_venueTypeId != v_orderVenueType THEN
        SIGNAL SQLSTATE '45074' SET MESSAGE_TEXT = 'Error: Discount code is not applicable for this venue type.';
    END IF;

    -- Check 4: Hạng thành viên (LOGIC MỚI)
    -- So sánh trực tiếp: Nếu Discount có quy định Tier thì khách PHẢI CÓ đúng Tier đó
    IF v_requiredTier IS NOT NULL AND v_clientTier != v_requiredTier THEN
        SIGNAL SQLSTATE '45075' SET MESSAGE_TEXT = 'Error: Your membership tier is not eligible for this discount.';
    END IF;

END$$
DELIMITER ;