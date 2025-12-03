import {
  Controller,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
} from '@nestjs/common';
import { VenueService } from '../services/venue.service';
import {
  CreateVenueDto,
  CreateVenueImageDto,
  CreateVenueTypeDto,
  UpdateVenueDto,
  UpdateVenueTypeDto,
  CreateRateDto,
  UpdateRateDto,
  CreateFavorDto,
} from '../dto/create-venue.dto';
import { AdminGuard, AuthGuard, OwnerGuard } from 'src/auth/guards';

@Controller('venue')
export class VenueController {
  constructor(private readonly venueService: VenueService) {}

  // ===== VENUE TYPE ENDPOINTS =====
  @Post('/types')
  @UseGuards(AdminGuard)
  async createVenueType(@Body() dto: CreateVenueTypeDto) {
    const venueTypeId = await this.venueService.createVenueType(dto);
    return { _id: venueTypeId };
  }

  @Patch('/types/:id')
  @UseGuards(AdminGuard)
  async updateVenueType(
    @Param('id') id: string,
    @Body() dto: UpdateVenueTypeDto,
  ) {
    await this.venueService.updateVenueType(id, dto);
    return { message: 'Venue type updated successfully' };
  }

  @Delete('/types/:id')
  @UseGuards(AdminGuard)
  async deleteVenueType(@Param('id') id: string) {
    await this.venueService.deleteVenueType(id);
    return { message: 'Venue type deleted successfully' };
  }

  // ===== VENUE ENDPOINTS =====
  @Post()
  @UseGuards(OwnerGuard)
  async createVenue(@Body() dto: CreateVenueDto) {
    await this.venueService.createVenue(dto);
    return { message: 'Venue created successfully' };
  }

  @Patch('/:locationId/:name')
  @UseGuards(OwnerGuard)
  async updateVenue(
    @Param('locationId') locationId: string,
    @Param('name') name: string,
    @Body() dto: UpdateVenueDto,
  ) {
    await this.venueService.updateVenue(locationId, name, dto);
    return { message: 'Venue updated successfully' };
  }

  @Delete('/:locationId/:name')
  @UseGuards(OwnerGuard)
  async deleteVenue(
    @Param('locationId') locationId: string,
    @Param('name') name: string,
  ) {
    await this.venueService.deleteVenue(locationId, name);
    return { message: 'Venue deleted successfully' };
  }

  // ===== VENUE IMAGE ENDPOINTS =====
  @Post('/images')
  @UseGuards(OwnerGuard)
  async createVenueImage(@Body() dto: CreateVenueImageDto) {
    const url = await this.venueService.createVenueImage(dto);
    return { url };
  }

  @Delete('/images/:locationId/:venueName/:url')
  @UseGuards(OwnerGuard)
  async deleteVenueImage(
    @Param('locationId') locationId: string,
    @Param('venueName') venueName: string,
    @Param('url') url: string,
  ) {
    await this.venueService.deleteVenueImage(locationId, venueName, url);
    return { message: 'Venue image deleted successfully' };
  }

  // ===== RATE ENDPOINTS =====
  @Post('/rates')
  @UseGuards(AuthGuard)
  async createRate(@Body() dto: CreateRateDto) {
    await this.venueService.createRate(dto);
    return { message: 'Rating created successfully' };
  }

  @Patch('/rates/:clientId/:locationId')
  @UseGuards(AuthGuard)
  async updateRate(
    @Param('clientId') clientId: string,
    @Param('locationId') locationId: string,
    @Body() dto: UpdateRateDto,
  ) {
    await this.venueService.updateRate(clientId, locationId, dto);
    return { message: 'Rating updated successfully' };
  }

  @Delete('/rates/:clientId/:locationId')
  @UseGuards(AuthGuard)
  async deleteRate(
    @Param('clientId') clientId: string,
    @Param('locationId') locationId: string,
  ) {
    await this.venueService.deleteRate(clientId, locationId);
    return { message: 'Rating deleted successfully' };
  }

  // ===== FAVOR ENDPOINTS =====
  @Post('/favors')
  @UseGuards(AuthGuard)
  async createFavor(@Body() dto: CreateFavorDto) {
    await this.venueService.createFavor(dto);
    return { message: 'Favorite added successfully' };
  }

  @Delete('/favors/:clientId/:locationId')
  @UseGuards(AuthGuard)
  async deleteFavor(
    @Param('clientId') clientId: string,
    @Param('locationId') locationId: string,
  ) {
    await this.venueService.deleteFavor(clientId, locationId);
    return { message: 'Favorite removed successfully' };
  }
}
