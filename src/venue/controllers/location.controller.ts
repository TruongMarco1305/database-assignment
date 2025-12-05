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
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { AuthGuard, OwnerGuard } from 'src/auth/guards';
import {
  CreateLocationDto,
  SearchLocationsDto,
  UpdateLocationDto,
} from '../dto/create-venue.dto';
import { User } from 'src/auth/decorators';
import { LocationService } from '../services/location.service';

@ApiTags('Locations')
@Controller('location')
export class LocationController {
  constructor(private readonly locationService: LocationService) {}

  @Post()
  @UseGuards(OwnerGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Create a new location' })
  @ApiResponse({ status: 201, description: 'Location created successfully' })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  @ApiResponse({ status: 403, description: 'Forbidden - Owner role required' })
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
  async getVenuesAtLocation(@Param('id') id: string) {
    const result = await this.locationService.getVenuesAtLocation(id);
    return result;
  }

  @Patch('/:id')
  @UseGuards(OwnerGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Update location details' })
  @ApiResponse({ status: 200, description: 'Location updated successfully' })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  @ApiResponse({ status: 403, description: 'Forbidden - Owner role required' })
  @ApiResponse({ status: 404, description: 'Location not found' })
  async update(@Param('id') id: string, @Body() dto: UpdateLocationDto) {
    await this.locationService.updateLocation(id, dto);
  }

  @Delete('/:id')
  @UseGuards(OwnerGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Delete a location' })
  @ApiResponse({ status: 200, description: 'Location deleted successfully' })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  @ApiResponse({ status: 403, description: 'Forbidden - Owner role required' })
  @ApiResponse({ status: 404, description: 'Location not found' })
  async delete(@Param('id') id: string) {
    await this.locationService.deleteLocation(id);
    return { message: 'Location deleted successfully' };
  }

  // ===== SEARCH LOCATIONS ENDPOINT =====
  @Post('/search')
  @UseGuards(AuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Search for available locations with filters' })
  @ApiResponse({
    status: 200,
    description: 'Search results returned successfully',
  })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
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
