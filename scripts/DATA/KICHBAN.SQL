user -> owner -> location -> venue -> amenity
user -> client -> search -> favor -> order -> invoice -> rate
user -> client -> search -> order -> cannot find that venue any

-- Cập nhật lại điểm cho toàn bộ Client dựa trên lịch sử đơn hàng
UPDATE clients c
LEFT JOIN (
    SELECT 
        client_id, 
        SUM(FLOOR(totalPrice / 10000)) AS total_calculated_points
    FROM orders
    WHERE status = 'COMPLETED'
    GROUP BY client_id
) o ON c.user_id = o.client_id
SET c.membership_points = IFNULL(o.total_calculated_points, 0);

client:
signup -> edit profile -> search location, venue -> like,reload -> filter -> make order -> choose amenity, apply discount -> confirm order -> gen QR -> invoice succeed -> view order history -> chat with owner -> completed order -> rating

owner:
signup -> edit profile -> create location, venue, venue_img, amenity -> view order, revenue

owner2:
signin -> view order, revenue, deactive location -> restrict if upcoming order exist, delete location -> restrict if exist completed order

admin:
signin -> create discount, venuetype -> manage user, location, order