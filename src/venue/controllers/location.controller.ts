import {
  Body,
  Controller,
  Post,
  Patch,
  Param,
  Delete,
  UseGuards,
  Get,
} from '@nestjs/common';
import { AuthGuard, OwnerGuard } from 'src/auth/guards';
import {
  CreateLocationDto,
  SearchLocationsDto,
  UpdateLocationDto,
} from '../dto/create-venue.dto';
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

  @Get('/:id/details')
  @UseGuards(OwnerGuard)
  async previewLocation(@Param('id') id: string, @User() user: Express.User) {
    const result = await this.locationService.previewLocation(user.userId, id);
    return result;
  }

  @Get('/:id/venues')
  @UseGuards(OwnerGuard)
  async getVenuesAtLocation(
    @Param('id') id: string,
    @User() user: Express.User,
  ) {
    const result = await this.locationService.getVenuesAtLocation(
      user.userId,
      id,
    );
    return result;
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

  // ===== SEARCH LOCATIONS ENDPOINT =====
  @Post('/search')
  @UseGuards(AuthGuard)
  async searchLocations(
    @Body() dto: SearchLocationsDto,
    @User() user: Express.User,
  ) {
    const results = await this.locationService.searchLocations(
      user.userId,
      dto,
    );
    return results;
  }

  @Get('/owner')
  @UseGuards(OwnerGuard)
  async getLocationsOfOwner(@User() user: Express.User) {
    const result = await this.locationService.getLocationsOfOwner(user.userId);
    return result;
  }
}
