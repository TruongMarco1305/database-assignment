import { Injectable } from '@nestjs/common';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';
import { DatabaseService } from 'src/database/database.service';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class OrderService {
  constructor(private databaseService: DatabaseService) {}

  public async createOrder(
    clientId: string,
    dto: CreateOrderDto,
  ): Promise<string> {
    const orderIdBinary = uuidv4();

    // 4. **Create Order Record:**
    await this.databaseService.execute(
      `
      CALL Order_Insert(?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
      `,
      [
        orderIdBinary,
        clientId,
        dto.locationId,
        dto.venueName,
        new Date(dto.startTime),
        new Date(dto.endTime),
      ],
    );

    if (dto.amenityIds && dto.amenityIds.length > 0) {
      // Run a loop or batch insert for order_amenities table
      for (const amenityId of dto.amenityIds) {
        await this.databaseService.execute(`CALL OrderAmenity_Insert(?, ?);`, [
          orderIdBinary,
          amenityId,
        ]);
      }
    }

    return orderIdBinary;
  }

  create(createOrderDto: CreateOrderDto) {
    return 'This action adds a new order';
  }

  findAll() {
    return `This action returns all order`;
  }

  findOne(id: number) {
    return `This action returns a #${id} order`;
  }

  update(id: number, updateOrderDto: UpdateOrderDto) {
    return `This action updates a #${id} order`;
  }

  remove(id: number) {
    return `This action removes a #${id} order`;
  }
}
