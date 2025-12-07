import { Injectable, ConflictException } from '@nestjs/common';
import {
  CreateOrderDto,
  UpdateOrderDto,
  AddOrderAmenityDto,
  RemoveOrderAmenityDto,
} from './dto/order.dto';
import { DatabaseService } from 'src/database/database.service';
import { v4 as uuidv4 } from 'uuid';
import * as dayjs from 'dayjs';

@Injectable()
export class OrderService {
  constructor(private databaseService: DatabaseService) {}

  // ===== ORDER OPERATIONS =====
  public async createOrder(
    clientId: string,
    dto: CreateOrderDto,
  ): Promise<{ expiredTime: Date; orderId: string }> {
    const orderId = uuidv4();

    try {
      await this.databaseService.execute(
        `CALL Order_Insert(?, ?, ?, ?, ?, ?)`,
        [
          orderId,
          clientId,
          dto.locationId,
          dto.venueName,
          new Date(dto.startTime),
          new Date(dto.endTime),
        ],
      );

      const expiredTime: Date = dayjs().add(15, 'minute').toDate();

      // Add amenities if provided
      if (dto.amenityIds && dto.amenityIds.length > 0) {
        for (const amenityId of dto.amenityIds) {
          await this.addOrderAmenity({
            orderId,
            amenityId,
          });
        }
      }

      if (dto.discountIds && dto.discountIds.length > 0) {
        for (const discountId of dto.discountIds) {
          await this.databaseService.execute(
            `CALL OrderDiscount_Insert(?, ?)`,
            [orderId, discountId],
          );
        }
      }

      return { expiredTime, orderId };
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to create order');
    }
  }

  public async getPreviewOrderMetadata(
    locationId: string,
    venueName: string,
    startTime: string,
    endTime: string,
    userId: string,
  ): Promise<any> {
    try {
      const amenities = await this.databaseService.execute(
        `CALL Get_Valid_Amenities(?, ?, ?, ?)`,
        [locationId, venueName, new Date(startTime), new Date(endTime)],
      );
      const discounts = await this.databaseService.execute(
        `CALL Get_Valid_Discounts(?, ?, ?, ?, ?)`,
        [userId, locationId, venueName, new Date(startTime), new Date(endTime)],
      );
      return { discounts, amenities };
    } catch (error) {
      throw new ConflictException(
        error.message || 'Failed to get discounts by venue',
      );
    }
  }

  public async updateOrder(id: string, dto: UpdateOrderDto): Promise<void> {
    try {
      await this.databaseService.execute(`CALL Order_Update(?, ?, ?, ?)`, [
        id,
        dto.totalPrice !== undefined ? dto.totalPrice : null,
        dto.points !== undefined ? dto.points : null,
        dto.status || null,
      ]);
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to update order');
    }
  }

  public async getUncompletedOrders(clientId: string): Promise<string> {
    try {
      const results = await this.databaseService.execute<{
        orderId: string;
        invoiceId: string;
      }>(`CALL Get_Uncompleted_Orders(?)`, [clientId]);
      const { orderId, invoiceId } = results[0];
      const data = await this.databaseService.execute<{
        totalPrice: string;
        accountNo: string;
        accountName: string;
        bankId: string;
      }>(`CALL GetInvoiceCreateData(?)`, [orderId]);
      const { totalPrice, accountNo, accountName, bankId } = data[0];
      return encodeURI(
        `https://img.vietqr.io/image/${bankId}-${accountNo}-compact.png?amount=${totalPrice}&addInfo=Pay%20for%20booking%20${invoiceId}&accountName=${accountName}`,
      );
    } catch (error) {
      throw new ConflictException(
        error.message || 'Failed to retrieve uncompleted orders',
      );
    }
  }

  public async deleteOrder(id: string): Promise<void> {
    try {
      await this.databaseService.execute(`CALL Order_Delete(?)`, [id]);
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to delete order');
    }
  }

  // ===== ORDER AMENITY OPERATIONS =====
  public async addOrderAmenity(dto: AddOrderAmenityDto): Promise<void> {
    try {
      await this.databaseService.execute(`CALL OrderAmenity_Insert(?, ?)`, [
        dto.orderId,
        dto.amenityId,
      ]);
    } catch (error) {
      throw new ConflictException(
        error.message || 'Failed to add amenity to order',
      );
    }
  }

  public async removeOrderAmenity(dto: RemoveOrderAmenityDto): Promise<void> {
    try {
      await this.databaseService.execute(`CALL OrderAmenity_Delete(?, ?)`, [
        dto.orderId,
        dto.amenityId,
      ]);
    } catch (error) {
      throw new ConflictException(
        error.message || 'Failed to remove amenity from order',
      );
    }
  }

  public async getOrdersByLocation(
    ownerId: string,
    orderQuery: {
      locationId?: string;
      orderStatus?: string;
      startDate?: string;
      endDate?: string;
    },
  ) {
    try {
      const results = await this.databaseService.execute(
        `CALL getOrdersForOwner(?, ?, ?, ?, ?)`,
        [
          ownerId,
          orderQuery.locationId || null,
          orderQuery.orderStatus || null,
          orderQuery.startDate ? new Date(orderQuery.startDate) : null,
          orderQuery.endDate ? new Date(orderQuery.endDate) : null,
        ],
      );
      return results;
    } catch (error) {
      throw new ConflictException(
        error.message || 'Failed to retrieve orders for owner',
      );
    }
  }
}
