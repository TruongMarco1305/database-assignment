import {
  Controller,
  Post,
  Patch,
  Param,
  Delete,
  Body,
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { AmenityService } from '../services/amenity.service';
import { CreateAmenityDto, UpdateAmenityDto } from '../dto/create-venue.dto';
import { OwnerGuard } from 'src/auth/guards';

@ApiTags('Amenities')
@Controller('amenity')
@UseGuards(OwnerGuard)
@ApiBearerAuth('JWT-auth')
export class AmenityController {
  constructor(private readonly amenityService: AmenityService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new amenity' })
  @ApiResponse({ status: 201, description: 'Amenity created successfully' })
  @ApiResponse({ status: 403, description: 'Forbidden - Owner role required' })
  async create(@Body() dto: CreateAmenityDto) {
    const amenityId = await this.amenityService.createAmenity(dto);
    return { _id: amenityId };
  }

  @Patch('/:id')
  @ApiOperation({ summary: 'Update amenity details' })
  @ApiResponse({ status: 200, description: 'Amenity updated successfully' })
  @ApiResponse({ status: 403, description: 'Forbidden - Owner role required' })
  @ApiResponse({ status: 404, description: 'Amenity not found' })
  async update(@Param('id') id: string, @Body() dto: UpdateAmenityDto) {
    await this.amenityService.updateAmenity(id, dto);
    return { message: 'Amenity updated successfully' };
  }

  @Delete('/:id')
  @ApiOperation({ summary: 'Delete an amenity' })
  @ApiResponse({ status: 200, description: 'Amenity deleted successfully' })
  @ApiResponse({ status: 403, description: 'Forbidden - Owner role required' })
  @ApiResponse({ status: 404, description: 'Amenity not found' })
  async delete(@Param('id') id: string) {
    await this.amenityService.deleteAmenity(id);
    return { message: 'Amenity deleted successfully' };
  }
}
