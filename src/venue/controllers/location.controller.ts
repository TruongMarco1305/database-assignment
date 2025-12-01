import { Body, Controller, Post } from '@nestjs/common';
// import { OwnerGuard } from 'src/auth/guards/owner.guard';
import { CreateLocationDto } from '../dto/create-venue.dto';
import { User } from 'src/auth/decorators';
import { LocationService } from '../services/location.service';

@Controller('location')
export class LocationController {
  constructor(private readonly locationService: LocationService) {}

  @Post()
  // @UseGuards(OwnerGuard)
  async create(
    @Body() createLocationDto: CreateLocationDto,
    @User() user: Express.User,
  ) {
    const locationId = await this.locationService.createLocation(
      user.userId,
      createLocationDto,
    );
    return {
      _id: locationId,
    };
  }
}
