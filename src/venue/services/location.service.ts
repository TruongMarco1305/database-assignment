import { Injectable } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { CreateLocationDto } from '../dto/create-venue.dto';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class LocationService {
  constructor(private databaseService: DatabaseService) {}

  public async createLocation(
    ownerId: string,
    dto: CreateLocationDto,
  ): Promise<string> {
    const locationId = uuidv4();

    await this.databaseService.execute(
      `
      CALL Location_Insert(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
      `,
      [
        locationId,
        ownerId,
        dto.name,
        dto.description || null,
        dto.addrNo,
        dto.ward,
        dto.city,
        dto.policy || null,
        dto.phoneNo || null,
        dto.mapURL,
        dto.thumbnailURL,
      ],
    );
    return locationId;
  }
}
