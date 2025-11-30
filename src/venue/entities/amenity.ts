export class Amenity {
  public amenity_id: Buffer; // BINARY(16) (Primary Key)
  public location_id: Buffer; // BINARY(16) (Foreign Key)
  public category: string; // VARCHAR(50)
  public description: string | null; // TEXT
  public isActive: boolean; // BOOLEAN (Default 1)
  public createdAt: Date; // DATETIME
  public updatedAt: Date; // DATETIME
}
