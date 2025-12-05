import { Injectable, ConflictException } from '@nestjs/common';
import {
  CreateOrderDto,
  UpdateOrderDto,
  AddOrderAmenityDto,
  RemoveOrderAmenityDto,
} from './dto/order.dto';
import { DatabaseService } from 'src/database/database.service';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class OrderService {
  constructor(private databaseService: DatabaseService) {}

  // ===== ORDER OPERATIONS =====
  public async createOrder(
    clientId: string,
    dto: CreateOrderDto,
  ): Promise<string> {
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

      // Add amenities if provided
      if (dto.amenityIds && dto.amenityIds.length > 0) {
        for (const amenityId of dto.amenityIds) {
          await this.addOrderAmenity({
            orderId,
            amenityId,
          });
        }
      }

      return orderId;
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to create order');
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
