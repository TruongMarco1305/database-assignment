import { ConflictException, Injectable } from '@nestjs/common';
import {
  CreateVenueDto,
  CreateVenueImageDto,
  CreateVenueTypeDto,
} from '../dto/create-venue.dto';
import { DatabaseService } from 'src/database/database.service';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class VenueService {
  constructor(private databaseService: DatabaseService) {}

  public async createVenueType(dto: CreateVenueTypeDto): Promise<string> {
    // 1. DTO validation handles minCapacity < maxCapacity check in code
    if (dto.minCapacity > dto.maxCapacity) {
      throw new ConflictException(
        'Minimum capacity cannot be greater than maximum capacity.',
      );
    }

    const venueTypeIdBinary = uuidv4();

    await this.databaseService.execute(
      `
      CALL VenueType_Insert(?, ?, ?, ?, ?, ?);
      `,
      [
        venueTypeIdBinary,
        dto.name,
        dto.description || null,
        dto.minCapacity,
        dto.maxCapacity,
        dto.area,
      ],
      {
        ER_DUP_ENTRY: () => {
          throw new ConflictException('Venue type name already exists.');
        },
      },
    );

    return venueTypeIdBinary;
  }

  public async createVenue(dto: CreateVenueDto): Promise<void> {
    await this.databaseService.execute(
      `
      CALL Venue_Insert(?, ?, ?, ?, ?);
      `,
      [dto.locationId, dto.name, dto.venueTypeId, dto.floor, dto.pricePerHour],
      {
        ER_DUP_ENTRY: () => {
          throw new ConflictException(
            `Venue named '${dto.name}' already exists at this location.`,
          );
        },
      },
    );
  }

  public async createVenueImage(dto: CreateVenueImageDto): Promise<string> {
    const imageIdBinary = uuidv4();

    await this.databaseService.execute(
      `
      CALL VenueImage_Insert(?, ?, ?, ?);
      `,
      [imageIdBinary, dto.locationId, dto.venueName, dto.locationImgURL],
      // No conflict handler needed unless you enforce unique image URLs
    );

    return imageIdBinary;
  }
}
