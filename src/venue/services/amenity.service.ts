import { Injectable, ConflictException } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { CreateAmenityDto, UpdateAmenityDto } from '../dto/create-venue.dto';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class AmenityService {
  constructor(private databaseService: DatabaseService) {}

  public async createAmenity(dto: CreateAmenityDto): Promise<string> {
    const amenityId = uuidv4();

    try {
      await this.databaseService.execute(
        `CALL Amenity_Insert(?, ?, ?, ?, ?, ?)`,
        [
          amenityId,
          dto.locationId,
          dto.category,
          dto.description || null,
          dto.price,
          dto.compatibleSize || null,
        ],
      );
      return amenityId;
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to create amenity');
    }
  }

  public async updateAmenity(id: string, dto: UpdateAmenityDto): Promise<void> {
    try {
      await this.databaseService.execute(
        `CALL Amenity_Update(?, ?, ?, ?, ?, ?)`,
        [
          id,
          dto.category || null,
          dto.description || null,
          dto.price !== undefined ? dto.price : null,
          dto.compatibleSize || null,
          dto.isActive !== undefined ? dto.isActive : null,
        ],
      );
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to update amenity');
    }
  }

  public async deleteAmenity(id: string): Promise<void> {
    try {
      await this.databaseService.execute(`CALL Amenity_Delete(?)`, [id]);
    } catch (error) {
      throw new ConflictException(error.message || 'Failed to delete amenity');
    }
  }
}
