import {
  Controller,
  Post,
  Patch,
  Param,
  Delete,
  Body,
  UseGuards,
} from '@nestjs/common';
import { AmenityService } from '../services/amenity.service';
import { CreateAmenityDto, UpdateAmenityDto } from '../dto/create-venue.dto';
import { OwnerGuard } from 'src/auth/guards';

@Controller('amenity')
@UseGuards(OwnerGuard)
export class AmenityController {
  constructor(private readonly amenityService: AmenityService) {}

  @Post()
  async create(@Body() dto: CreateAmenityDto) {
    const amenityId = await this.amenityService.createAmenity(dto);
    return { _id: amenityId };
  }

  @Patch('/:id')
  async update(@Param('id') id: string, @Body() dto: UpdateAmenityDto) {
    await this.amenityService.updateAmenity(id, dto);
    return { message: 'Amenity updated successfully' };
  }

  @Delete('/:id')
  async delete(@Param('id') id: string) {
    await this.amenityService.deleteAmenity(id);
    return { message: 'Amenity deleted successfully' };
  }
}
