-- order
DELIMITER $$

CREATE TRIGGER Check_OverlapOrder
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    -- Kiểm tra trùng lịch
    IF EXISTS (
        SELECT 1 FROM orders
        WHERE venue_loc_id = NEW.venue_loc_id 
          AND venueName = NEW.venueName
          AND status IN ('PENDING', 'CONFIRMED') -- Chỉ chặn các đơn đang hoạt động
          AND (startHour < NEW.endHour AND endHour > NEW.startHour) -- Logic chồng lấn thời gian
    ) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: This venue is already booked for the selected time slot.';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER Check_Active
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE v_venueActive BOOLEAN;
    DECLARE v_locationActive BOOLEAN;

    -- Lấy trạng thái của Venue và Location cha
    SELECT v.isActive, l.isActive 
    INTO v_venueActive, v_locationActive
    FROM venues v
    JOIN locations l ON v.location_id = l.location_id
    WHERE v.location_id = NEW.venue_loc_id 
      AND v.name = NEW.venueName;

    -- Kiểm tra
    IF v_locationActive = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: This Location is currently inactive/closed.';
    END IF;

    IF v_venueActive = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: This Venue is currently under maintenance or inactive.';
    END IF;
END$$

DELIMITER ;

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
    DECLARE v_tiers SET('BRONZE', 'SILVER', 'GOLD', 'PLATINUM');
    
    -- Khai báo biến để lưu thông tin Order & Client
    DECLARE v_orderTotal DECIMAL(12,2);
    DECLARE v_bookingDate DATETIME;
    DECLARE v_orderVenueType BINARY(16);
    DECLARE v_clientPoints INT;          -- Thay vì lấy Tier, ta lấy Points
    DECLARE v_calculatedTier VARCHAR(20); -- Biến lưu Tier sau khi tính

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
    SET v_clientTier = Get_Tier(v_clientPoints);

    -- 3. Bắt đầu kiểm tra
    -- Check 1: Thời gian hiệu lực (So với ngày tạo đơn)
    IF v_bookingDate < v_start OR v_bookingDate > v_end THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Discount code is expired or not yet active.';
    END IF;

    -- Check 2: Đơn hàng tối thiểu
    IF v_minPrice IS NOT NULL AND v_orderTotal < v_minPrice THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order amount does not meet the minimum requirement for this discount.';
    END IF;

    -- Check 3: Loại phòng (Nếu discount có quy định)
    IF v_venueTypeId IS NOT NULL AND v_venueTypeId != v_orderVenueType THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Discount code is not applicable for this venue type.';
    END IF;

    -- Check 4: Hạng thành viên (Nếu discount có quy định)
    -- Dùng FIND_IN_SET vì membershipTier là kiểu SET
    IF v_tiers IS NOT NULL AND NOT FIND_IN_SET(v_clientTier, v_tiers) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Your membership tier is not eligible for this discount.';
    END IF;

END$$

DELIMITER ;

-- invoice
DELIMITER $$

CREATE TRIGGER Check_Amount
BEFORE INSERT ON invoices
FOR EACH ROW
BEGIN
    DECLARE v_orderTotal DECIMAL(12,2);

    -- Lấy tổng tiền từ đơn hàng tương ứng
    SELECT totalPrice INTO v_orderTotal
    FROM orders
    WHERE order_id = NEW.order_id;

    -- So sánh (Cho phép lệch 0 đồng, bắt buộc khớp chính xác)
    IF NEW.amount != v_orderTotal THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Invoice amount must match the Order total price.';
    END IF;
END$$

DELIMITER ;

-- rate
DELIMITER $$

CREATE TRIGGER Check_Rate
BEFORE INSERT ON rates
FOR EACH ROW
BEGIN
    -- Kiểm tra xem có tồn tại đơn hàng hợp lệ nào không
    IF NOT EXISTS (
        SELECT 1 
        FROM orders o
        -- Join để đảm bảo Order đó thuộc về Location đang được rate
        -- (Vì bảng Order lưu venue_loc_id chính là location_id)
        WHERE o.client_id = NEW.client_id 
          AND o.venue_loc_id = NEW.location_id
          AND o.status = 'COMPLETED' -- Hoặc trạng thái đã hoàn thành nếu có
          AND o.endHour < NOW()      -- Phải sử dụng xong mới được review
    ) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: You can only rate a location after completing a booking there.';
    END IF;
END$$
