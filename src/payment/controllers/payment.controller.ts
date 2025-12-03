import {
  Controller,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
} from '@nestjs/common';
import { PaymentService } from '../services/payment.service';
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
import { AuthGuard } from 'src/auth/guards';

@Controller('payment')
@UseGuards(AuthGuard)
export class PaymentController {
  constructor(private readonly paymentService: PaymentService) {}

  // ===== INVOICE ENDPOINTS =====
  @Post('/invoices')
  async createInvoice(@Body() dto: CreateInvoiceDto) {
    const invoiceId = await this.paymentService.createInvoice(dto);
    return { _id: invoiceId };
  }

  @Patch('/invoices/complete')
  async completeInvoicePayment(@Body() dto: CompleteInvoicePaymentDto) {
    await this.paymentService.completeInvoicePayment(dto);
    return { message: 'Invoice payment completed successfully' };
  }

  @Patch('/invoices/status')
  async updateInvoiceStatus(@Body() dto: UpdateInvoiceStatusDto) {
    await this.paymentService.updateInvoiceStatus(dto);
    return { message: 'Invoice status updated successfully' };
  }

  // ===== DISCOUNT ENDPOINTS =====
  @Post('/discounts')
  async createDiscount(@Body() dto: CreateDiscountDto) {
    const discountId = await this.paymentService.createDiscount(dto);
    return { _id: discountId };
  }

  @Patch('/discounts/:id')
  async updateDiscount(
    @Param('id') id: string,
    @Body() dto: UpdateDiscountDto,
  ) {
    await this.paymentService.updateDiscount(id, dto);
    return { message: 'Discount updated successfully' };
  }

  @Delete('/discounts/:id')
  async deleteDiscount(@Param('id') id: string) {
    await this.paymentService.deleteDiscount(id);
    return { message: 'Discount deleted successfully' };
  }

  // ===== APPLY DISCOUNT ENDPOINTS =====
  @Post('/applies')
  async applyDiscount(@Body() dto: CreateApplyDto) {
    await this.paymentService.applyDiscount(dto);
    return { message: 'Discount applied successfully' };
  }

  @Patch('/applies')
  async updateApply(@Body() dto: UpdateApplyDto) {
    await this.paymentService.updateApply(dto);
    return { message: 'Discount updated successfully' };
  }

  @Delete('/applies')
  async removeDiscount(@Body() dto: DeleteApplyDto) {
    await this.paymentService.removeDiscount(dto);
    return { message: 'Discount removed successfully' };
  }
}
