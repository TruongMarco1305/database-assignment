import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
} from '@nestjs/common';
import { VenueService } from '../services/venue.service';
import {
  CreateVenueDto,
  CreateVenueImageDto,
  CreateVenueTypeDto,
} from '../dto/create-venue.dto';
import { UpdateVenueDto } from '../dto/update-venue.dto';

@Controller('venue')
export class VenueController {
  constructor(private readonly venueService: VenueService) {}

  @Post()
  async createVenue(@Body() dto: CreateVenueDto) {
    await this.venueService.createVenue(dto);
  }

  @Post('/types')
  async createVenueType(@Body() createVenueTypeDto: CreateVenueTypeDto) {
    const venueTypeId =
      await this.venueService.createVenueType(createVenueTypeDto);
    return { _id: venueTypeId };
  }

  @Post('/images')
  async createVenueImage(@Body() createVenueImageDto: CreateVenueImageDto) {
    const imageId =
      await this.venueService.createVenueImage(createVenueImageDto);
    return { _id: imageId };
  }

  @Get()
  findAll() {
    return this.venueService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.venueService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateVenueDto: UpdateVenueDto) {
    return this.venueService.update(+id, updateVenueDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.venueService.remove(+id);
  }
}
