import {
  Body,
  Controller,
  Post,
  Patch,
  Param,
  Delete,
  UseGuards,
} from '@nestjs/common';
import { OwnerGuard } from 'src/auth/guards';
import { CreateLocationDto, UpdateLocationDto } from '../dto/create-venue.dto';
import { User } from 'src/auth/decorators';
import { LocationService } from '../services/location.service';

@Controller('location')
export class LocationController {
  constructor(private readonly locationService: LocationService) {}

  @Post()
  @UseGuards(OwnerGuard)
  async create(@Body() dto: CreateLocationDto, @User() user: Express.User) {
    const locationId = await this.locationService.createLocation(
      user.userId,
      dto,
    );
    return { _id: locationId };
  }

  @Patch('/:id')
  @UseGuards(OwnerGuard)
  async update(@Param('id') id: string, @Body() dto: UpdateLocationDto) {
    await this.locationService.updateLocation(id, dto);
    return { message: 'Location updated successfully' };
  }

  @Delete('/:id')
  @UseGuards(OwnerGuard)
  async delete(@Param('id') id: string) {
    await this.locationService.deleteLocation(id);
    return { message: 'Location deleted successfully' };
  }
}
