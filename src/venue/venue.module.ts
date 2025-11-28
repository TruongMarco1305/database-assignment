import { Module } from '@nestjs/common';
import { VenueService } from './services/venue.service';
import { VenueController } from './controllers/venue.controller';

@Module({
  controllers: [VenueController],
  providers: [VenueService],
})
export class VenueModule {}
