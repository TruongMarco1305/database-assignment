import {
  ConflictException,
  Injectable,
  BadRequestException,
} from '@nestjs/common';
import {
  CreateVenueDto,
  CreateVenueImageDto,
  CreateVenueTypeDto,
  UpdateVenueDto,
  UpdateVenueTypeDto,
  CreateRateDto,
  UpdateRateDto,
  CreateFavorDto,
} from '../dto/create-venue.dto';
import { DatabaseService } from 'src/database/database.service';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class VenueService {
  constructor(private databaseService: DatabaseService) {}

  // ===== VENUE TYPE OPERATIONS =====
  public async createVenueType(dto: CreateVenueTypeDto): Promise<string> {
    if (dto.minCapacity > dto.maxCapacity) {
      throw new BadRequestException(
        'Minimum capacity cannot be greater than maximum capacity.',
      );
    }

    const venueTypeId = uuidv4();

    try {
      await this.databaseService.execute(
        `CALL VenueType_Insert(?, ?, ?, ?, ?)`,
        [
          venueTypeId,
          dto.name,
          dto.description || null,
          dto.minCapacity,
          dto.maxCapacity,
        ],
      );
      return venueTypeId;
    } catch (error) {
      throw new ConflictException(
        error.message || 'Failed to create venue type',
      );
    }
  }

  public async getVenueTypes() {
    return await this.databaseService.execute(`CALL GetVenueTypesInfo()`);
  }

  public async updateVenueType(
    id: string,
    dto: UpdateVenueTypeDto,
  ): Promise<void> {
    try {
      await this.databaseService.execute(
        `CALL VenueType_Update(?, ?, ?, ?, ?)`,
        [
          id,
          dto.name || null,
          dto.description || null,
          dto.minCapacity || null,
          dto.maxCapacity || null,
        ],
      );
    } catch (error) {
      throw new ConflictException(
        error.message || 'Failed to update venue type',
      );
    }
  }

  public async deleteVenueType(id: string): Promise<void> {
    try {
      await this.databaseService.execute(`CALL VenueType_Delete(?)`, [id]);
    } catch (error) {
      throw new ConflictException(
        error.message || 'Failed to delete venue type',
      );
    }
  }

  // ===== VENUE OPERATIONS =====
  public async createVenue(dto: CreateVenueDto): Promise<void> {
    try {
      await this.databaseService.execute(
        `CALL Venue_Insert(?, ?, ?, ?, ?, ?)`,
        [
          dto.locationId,
          dto.name,
          dto.venueTypeId,
          dto.floor,
          dto.area,
          dto.pricePerHour,
        ],
      );
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to create venue');
    }
  }

  public async updateVenue(
    locationId: string,
    name: string,
    dto: UpdateVenueDto,
  ): Promise<void> {
    try {
      await this.databaseService.execute(
        `CALL Venue_Update(?, ?, ?, ?, ?, ?, ?)`,
        [
          locationId,
          name,
          dto.typeId || null,
          dto.floor || null,
          dto.area || null,
          dto.pricePerHour || null,
          dto.isActive !== undefined ? dto.isActive : null,
        ],
      );
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to update venue');
    }
  }

  public async deleteVenue(locationId: string, name: string): Promise<void> {
    try {
      await this.databaseService.execute(`CALL Venue_Delete(?, ?)`, [
        locationId,
        name,
      ]);
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to delete venue');
    }
  }

  // ===== VENUE IMAGE OPERATIONS =====
  public async createVenueImage(dto: CreateVenueImageDto): Promise<string> {
    try {
      await this.databaseService.execute(`CALL VenueImage_Insert(?, ?, ?)`, [
        dto.locationId,
        dto.venueName,
        dto.url,
      ]);
      return dto.url; // Return the URL as identifier
    } catch (error) {
      throw new ConflictException(
        error.message || 'Failed to create venue image',
      );
    }
  }

  public async deleteVenueImage(
    locationId: string,
    venueName: string,
    url: string,
  ): Promise<void> {
    try {
      await this.databaseService.execute(`CALL VenueImage_Delete(?, ?, ?)`, [
        locationId,
        venueName,
        url,
      ]);
    } catch (error) {
      throw new ConflictException(
        error.message || 'Failed to delete venue image',
      );
    }
  }

  // ===== RATE OPERATIONS =====
  public async createRate(dto: CreateRateDto): Promise<void> {
    try {
      await this.databaseService.execute(`CALL Rate_Insert(?, ?, ?, ?)`, [
        dto.clientId,
        dto.locationId,
        dto.stars,
        dto.comment || null,
      ]);
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to create rate');
    }
  }

  public async updateRate(
    clientId: string,
    locationId: string,
    dto: UpdateRateDto,
  ): Promise<void> {
    try {
      await this.databaseService.execute(`CALL Rate_Update(?, ?, ?, ?)`, [
        clientId,
        locationId,
        dto.stars || null,
        dto.comment || null,
      ]);
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to update rate');
    }
  }

  public async deleteRate(clientId: string, locationId: string): Promise<void> {
    try {
      await this.databaseService.execute(`CALL Rate_Delete(?, ?)`, [
        clientId,
        locationId,
      ]);
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to delete rate');
    }
  }

  // ===== FAVOR OPERATIONS =====
  public async createFavor(dto: CreateFavorDto): Promise<void> {
    try {
      await this.databaseService.execute(`CALL Favor_Insert(?, ?)`, [
        dto.clientId,
        dto.locationId,
      ]);
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to create favor');
    }
  }

  public async deleteFavor(
    clientId: string,
    locationId: string,
  ): Promise<void> {
    try {
      await this.databaseService.execute(`CALL Favor_Delete(?, ?)`, [
        clientId,
        locationId,
      ]);
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to delete favor');
    }
  }

  // ===== AMENITY OPERATIONS =====
  // Amenity operations are handled by AmenityService
}
