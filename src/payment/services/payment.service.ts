import { Injectable, ConflictException } from '@nestjs/common';
import {
  CreateInvoiceDto,
  CompleteInvoicePaymentDto,
  UpdateInvoiceStatusDto,
  CreateDiscountDto,
  UpdateDiscountDto,
  CreateApplyDto,
  UpdateApplyDto,
  DeleteApplyDto,
} from '../dto/payment.dto';
import { DatabaseService } from 'src/database/database.service';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class PaymentService {
  constructor(private databaseService: DatabaseService) {}

  // ===== INVOICE OPERATIONS =====
  public async createInvoice(dto: CreateInvoiceDto): Promise<string> {
    const invoiceId = uuidv4();

    try {
      await this.databaseService.execute(`CALL Invoice_Insert(?, ?, ?)`, [
        invoiceId,
        dto.orderId,
        dto.amount,
      ]);
      return invoiceId;
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to create invoice');
    }
  }

  public async completeInvoicePayment(
    dto: CompleteInvoicePaymentDto,
  ): Promise<void> {
    try {
      await this.databaseService.execute(
        `CALL Invoice_CompletePayment(?, ?, ?, ?, ?)`,
        [
          dto.id,
          dto.senderBank || null,
          dto.receiverBank || null,
          dto.transactionId,
          dto.description || null,
        ],
      );
    } catch (error) {
      throw new ConflictException(
        error.message || 'Failed to complete invoice payment',
      );
    }
  }

  public async updateInvoiceStatus(dto: UpdateInvoiceStatusDto): Promise<void> {
    try {
      await this.databaseService.execute(`CALL Invoice_UpdateStatus(?, ?, ?)`, [
        dto.id,
        dto.status,
        dto.description || null,
      ]);
    } catch (error) {
      throw new ConflictException(
        error.message || 'Failed to update invoice status',
      );
    }
  }

  // ===== DISCOUNT OPERATIONS =====
  public async createDiscount(dto: CreateDiscountDto): Promise<string> {
    const discountId = uuidv4();

    try {
      await this.databaseService.execute(
        `CALL Discount_Insert(?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          discountId,
          dto.name,
          dto.percentage,
          dto.maxDiscountPrice || null,
          dto.minPrice || null,
          dto.venueTypeId || null,
          dto.membershipTier || null,
          new Date(dto.startedAt),
          new Date(dto.expiredAt),
        ],
      );
      return discountId;
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to create discount');
    }
  }

  public async updateDiscount(
    id: string,
    dto: UpdateDiscountDto,
  ): Promise<void> {
    try {
      await this.databaseService.execute(
        `CALL Discount_Update(?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          id,
          dto.name || null,
          dto.percentage || null,
          dto.maxDiscountPrice !== undefined ? dto.maxDiscountPrice : null,
          dto.minPrice !== undefined ? dto.minPrice : null,
          dto.venueTypeId || null,
          dto.membershipTier || null,
          dto.startedAt ? new Date(dto.startedAt) : null,
          dto.expiredAt ? new Date(dto.expiredAt) : null,
        ],
      );
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to update discount');
    }
  }

  public async deleteDiscount(id: string): Promise<void> {
    try {
      await this.databaseService.execute(`CALL Discount_Delete(?)`, [id]);
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to delete discount');
    }
  }

  // ===== APPLY OPERATIONS =====
  public async applyDiscount(dto: CreateApplyDto): Promise<void> {
    try {
      await this.databaseService.execute(`CALL Applies_Insert(?, ?)`, [
        dto.orderId,
        dto.discountId,
      ]);
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to apply discount');
    }
  }

  public async updateApply(dto: UpdateApplyDto): Promise<void> {
    try {
      await this.databaseService.execute(`CALL Applies_Update(?, ?, ?)`, [
        dto.orderId,
        dto.oldDiscountId,
        dto.newDiscountId,
      ]);
    } catch (error) {
      throw new ConflictException(
        error.message || 'Failed to update applied discount',
      );
    }
  }

  public async removeDiscount(dto: DeleteApplyDto): Promise<void> {
    try {
      await this.databaseService.execute(`CALL Applies_Delete(?, ?)`, [
        dto.orderId,
        dto.discountId,
      ]);
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to remove discount');
    }
  }
}
