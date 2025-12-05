import {
  Controller,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Get,
  Query,
} from '@nestjs/common';
import { OrderService } from './order.service';
import {
  CreateOrderDto,
  UpdateOrderDto,
  AddOrderAmenityDto,
  RemoveOrderAmenityDto,
} from './dto/order.dto';
import { AuthGuard, OwnerGuard } from 'src/auth/guards';
import { User } from 'src/auth/decorators';

@Controller('order')
export class OrderController {
  constructor(private readonly orderService: OrderService) {}

  // ===== ORDER ENDPOINTS =====
  @Post()
  @UseGuards(AuthGuard)
  async create(@Body() dto: CreateOrderDto, @User() user: Express.User) {
    const orderId = await this.orderService.createOrder(user.userId, dto);
    return { _id: orderId };
  }

  @Patch('/:id')
  @UseGuards(AuthGuard)
  async update(@Param('id') id: string, @Body() dto: UpdateOrderDto) {
    await this.orderService.updateOrder(id, dto);
    return { message: 'Order updated successfully' };
  }

  @Delete('/:id')
  @UseGuards(AuthGuard)
  async remove(@Param('id') id: string) {
    await this.orderService.deleteOrder(id);
    return { message: 'Order deleted successfully' };
  }

  // ===== ORDER AMENITY ENDPOINTS =====
  @Post('/amenities')
  @UseGuards(OwnerGuard)
  async addAmenity(@Body() dto: AddOrderAmenityDto) {
    await this.orderService.addOrderAmenity(dto);
    return { message: 'Amenity added to order successfully' };
  }

  @Delete('/amenities')
  @UseGuards(OwnerGuard)
  async removeAmenity(@Body() dto: RemoveOrderAmenityDto) {
    await this.orderService.removeOrderAmenity(dto);
    return { message: 'Amenity removed from order successfully' };
  }

  @Get('/owner')
  @UseGuards(OwnerGuard)
  async getOrdersByLocation(
    @Query()
    orderQuery: {
      locationId?: string;
      orderStatus?: string;
      startDate?: string;
      endDate?: string;
    },
    @User() user: Express.User,
  ) {
    const orders = await this.orderService.getOrdersByLocation(
      user.userId,
      orderQuery,
    );
    return orders;
  }
}
