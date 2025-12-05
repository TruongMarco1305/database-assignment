import {
  Controller,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
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

@ApiTags('Venues')
@Controller('venue')
export class VenueController {
  constructor(private readonly venueService: VenueService) {}

  // ===== VENUE TYPE ENDPOINTS =====
  @Post('/types')
  @UseGuards(AdminGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Create a new venue type (Admin only)' })
  @ApiResponse({ status: 201, description: 'Venue type created successfully' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin role required' })
  async createVenueType(@Body() dto: CreateVenueTypeDto) {
    const venueTypeId = await this.venueService.createVenueType(dto);
    return { _id: venueTypeId };
  }

  @Patch('/types/:id')
  @UseGuards(AdminGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Update venue type (Admin only)' })
  @ApiResponse({ status: 200, description: 'Venue type updated successfully' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin role required' })
  @ApiResponse({ status: 404, description: 'Venue type not found' })
  async updateVenueType(
    @Param('id') id: string,
    @Body() dto: UpdateVenueTypeDto,
  ) {
    await this.venueService.updateVenueType(id, dto);
    return { message: 'Venue type updated successfully' };
  }

  @Delete('/types/:id')
  @UseGuards(AdminGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Delete venue type (Admin only)' })
  @ApiResponse({ status: 200, description: 'Venue type deleted successfully' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin role required' })
  @ApiResponse({ status: 404, description: 'Venue type not found' })
  async deleteVenueType(@Param('id') id: string) {
    await this.venueService.deleteVenueType(id);
    return { message: 'Venue type deleted successfully' };
  }

  // ===== VENUE ENDPOINTS =====
  @Post()
  @UseGuards(OwnerGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Create a new venue' })
  @ApiResponse({ status: 201, description: 'Venue created successfully' })
  @ApiResponse({ status: 403, description: 'Forbidden - Owner role required' })
  async createVenue(@Body() dto: CreateVenueDto) {
    await this.venueService.createVenue(dto);
    return { message: 'Venue created successfully' };
  }

  @Patch('/:locationId/:name')
  @UseGuards(OwnerGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Update venue details' })
  @ApiResponse({ status: 200, description: 'Venue updated successfully' })
  @ApiResponse({ status: 403, description: 'Forbidden - Owner role required' })
  @ApiResponse({ status: 404, description: 'Venue not found' })
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
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Delete a venue' })
  @ApiResponse({ status: 200, description: 'Venue deleted successfully' })
  @ApiResponse({ status: 403, description: 'Forbidden - Owner role required' })
  @ApiResponse({ status: 404, description: 'Venue not found' })
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
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Add an image to a venue' })
  @ApiResponse({ status: 201, description: 'Image added successfully' })
  @ApiResponse({ status: 403, description: 'Forbidden - Owner role required' })
  async createVenueImage(@Body() dto: CreateVenueImageDto) {
    const url = await this.venueService.createVenueImage(dto);
    return { url };
  }

  @Delete('/images/:locationId/:venueName/:url')
  @UseGuards(OwnerGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Remove an image from a venue' })
  @ApiResponse({ status: 200, description: 'Image deleted successfully' })
  @ApiResponse({ status: 403, description: 'Forbidden - Owner role required' })
  @ApiResponse({ status: 404, description: 'Image not found' })
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
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Rate a location' })
  @ApiResponse({ status: 201, description: 'Rating created successfully' })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  async createRate(@Body() dto: CreateRateDto) {
    await this.venueService.createRate(dto);
    return { message: 'Rating created successfully' };
  }

  @Patch('/rates/:clientId/:locationId')
  @UseGuards(AuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Update an existing rating' })
  @ApiResponse({ status: 200, description: 'Rating updated successfully' })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  @ApiResponse({ status: 404, description: 'Rating not found' })
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
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Delete a rating' })
  @ApiResponse({ status: 200, description: 'Rating deleted successfully' })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  @ApiResponse({ status: 404, description: 'Rating not found' })
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
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Add location to favorites' })
  @ApiResponse({ status: 201, description: 'Favorite added successfully' })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  async createFavor(@Body() dto: CreateFavorDto) {
    await this.venueService.createFavor(dto);
    return { message: 'Favorite added successfully' };
  }

  @Delete('/favors/:clientId/:locationId')
  @UseGuards(AuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Remove location from favorites' })
  @ApiResponse({ status: 200, description: 'Favorite removed successfully' })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  @ApiResponse({ status: 404, description: 'Favorite not found' })
  async deleteFavor(
    @Param('clientId') clientId: string,
    @Param('locationId') locationId: string,
  ) {
    await this.venueService.deleteFavor(clientId, locationId);
    return { message: 'Favorite removed successfully' };
  }
}
