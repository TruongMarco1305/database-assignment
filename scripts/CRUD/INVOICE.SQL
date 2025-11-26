-- invoice
DELIMITER $$

-- 1. Invoice_Create (TỐI ƯU: Bỏ tham số status)
CREATE PROCEDURE Invoice_Create(
    IN p_id VARCHAR(36),
    IN p_orderId VARCHAR(36),
    IN p_amount DECIMAL(12,2)
)
BEGIN
    -- Chỉ insert 3 cột cốt lõi. 
    -- Cột 'status' sẽ tự động nhận giá trị 'PENDING' từ Default của bảng.
    -- Các cột bank, transaction, paidOn, description sẽ tự nhận NULL.
    INSERT INTO invoices (
        invoice_id, 
        order_id, 
        amount
    )
    VALUES (
        UUID_TO_BIN(p_id), 
        UUID_TO_BIN(p_orderId), 
        p_amount
    );
END$$

-- 2. Invoice_CompletePayment
-- THÊM tham số p_desc để nhận nội dung từ ngân hàng (VD: "KH Tran Van A chuyen khoan...")
CREATE PROCEDURE Invoice_CompletePayment(
    IN p_id VARCHAR(36),
    IN p_senderBank VARCHAR(50),
    IN p_recvBank VARCHAR(50),
    IN p_transId VARCHAR(50),
    IN p_desc TEXT  -- <--- Bổ sung tham số này
)
BEGIN
    UPDATE invoices 
    SET 
        status = 'SUCCEEDED',
        senderBankAccount = p_senderBank,
        receiverBankAccount = p_recvBank,
        transaction_id = p_transId,
        description = p_desc, -- <--- Cập nhật nội dung tại đây
        paidOn = NOW()
    WHERE invoice_id = UUID_TO_BIN(p_id);
END$$

-- 3. Invoice_UpdateStatus (Dùng cho FAILED/REFUNDED)
-- Cũng nên cho phép cập nhật lý do lỗi vào description
CREATE PROCEDURE Invoice_UpdateStatus(
    IN p_id VARCHAR(36),
    IN p_status VARCHAR(20),
    IN p_desc TEXT -- <--- Thêm lý do lỗi (VD: "Số dư không đủ")
)
BEGIN
    UPDATE invoices 
    SET 
        status = p_status,
        description = p_desc
    WHERE invoice_id = UUID_TO_BIN(p_id);
END$$

-- 4. Invoice_Delete (Giữ nguyên)
CREATE PROCEDURE Invoice_Delete(IN p_id VARCHAR(36))
BEGIN
    DELETE FROM invoices WHERE invoice_id = UUID_TO_BIN(p_id);
END$$

DELIMITER ;
