import { Controller, Post, Body } from '@nestjs/common';
import { VenueService } from '../services/venue.service';
import {
  CreateVenueDto,
  CreateVenueImageDto,
  CreateVenueTypeDto,
} from '../dto/create-venue.dto';

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
}
