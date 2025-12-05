import { Injectable, ConflictException } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import {
  CreateLocationDto,
  SearchLocationsDto,
  UpdateLocationDto,
} from '../dto/create-venue.dto';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class LocationService {
  constructor(private databaseService: DatabaseService) {}

  public async createLocation(
    ownerId: string,
    dto: CreateLocationDto,
  ): Promise<string> {
    const locationId = uuidv4();

    try {
      await this.databaseService.execute(
        `CALL Location_Insert(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          locationId,
          ownerId,
          dto.name,
          dto.description || null,
          dto.addrNo,
          dto.ward,
          dto.city,
          dto.phoneNo || null,
          dto.policy || null,
          dto.mapURL,
          dto.thumbnailURL,
        ],
      );
      return locationId;
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to create location');
    }
  }

  public async updateLocation(
    id: string,
    dto: UpdateLocationDto,
  ): Promise<void> {
    try {
      await this.databaseService.execute(
        `CALL Location_Update(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          id,
          dto.name || null,
          dto.description || null,
          dto.addrNo || null,
          dto.ward || null,
          dto.city || null,
          dto.phoneNo || null,
          dto.policy || null,
          dto.mapURL || null,
          dto.thumbnailURL || null,
          dto.isActive !== undefined ? dto.isActive : null,
        ],
      );
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to update location');
    }
  }

  public async deleteLocation(id: string): Promise<void> {
    try {
      await this.databaseService.execute(`CALL Location_Delete(?)`, [id]);
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to delete location');
    }
  }

  // ===== SEARCH LOCATIONS OPERATION =====
  public async searchLocations(
    clientId: string | null,
    dto: SearchLocationsDto,
  ): Promise<any[]> {
    try {
      const result = await this.databaseService.execute<any>(
        `CALL getListLocations(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          dto.city,
          dto.startTime ? new Date(dto.startTime) : null,
          dto.endTime ? new Date(dto.endTime) : null,
          dto.minPrice || null,
          dto.maxPrice || null,
          dto.minAvgRating || null,
          dto.theme || null,
          dto.size || null,
          dto.amenityCategory || null,
          dto.sort || null,
          clientId,
        ],
      );
      return result;
    } catch (error) {
      throw new ConflictException(
        error.message || 'Failed to search locations',
      );
    }
  }

  public async getLocationsOfOwner(userId: string) {
    try {
      const result = await this.databaseService.execute<any>(
        `CALL listLocationOfOwner(?)`,
        [userId],
      );
      return result;
    } catch (error) {
      throw new ConflictException(
        error.message || 'Failed to search locations',
      );
    }
  }

  public async previewLocation(userid: string, id: string): Promise<any> {
    try {
      const result = await this.databaseService.execute<any>(
        `CALL getLocationDetailById(?, ?)`,
        [userid, id],
      );
      return result[0];
    } catch (error) {
      throw new ConflictException(
        error.message || 'Failed to preview location',
      );
    }
  }

  public async getVenuesAtLocation(userid: string, id: string) {
    try {
      const result = await this.databaseService.execute<any>(
        `CALL listVenueOfLocation(?, ?)`,
        [userid, id],
      );
      return result;
    } catch (error) {
      throw new ConflictException(
        error.message || 'Failed to get location detail',
      );
    }
  }
}
