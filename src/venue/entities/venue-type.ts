export class VenueType {
  public venueType_id: Buffer; // BINARY(16) (Primary Key)
  public name: string; // VARCHAR(50)
  public description: string | null; // TEXT
  public minCapacity: number; // INT
  public maxCapacity: number; // INT
  public area: number; // DECIMAL(10, 1)
  public createdAt: Date; // DATETIME
  public updatedAt: Date; // DATETIME
}
