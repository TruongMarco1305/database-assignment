export class Venue {
  public location_id: Buffer; // BINARY(16) (Foreign Key)
  public name: string; // VARCHAR(100)
  public venueType_id: Buffer | null; // BINARY(16) (Foreign Key)
  public floor: string; // VARCHAR(10)
  public pricePerHour: number; // DECIMAL(10, 2)
  public isActive: boolean; // BOOLEAN (Default 1)
  public createdAt: Date; // DATETIME
  public updatedAt: Date; // DATETIME
}
