export class Location {
  public location_id: Buffer; // BINARY(16) (Primary Key)
  public owner_id: Buffer; // BINARY(16) (Foreign Key)
  public name: string; // VARCHAR(150)
  public description: string | null; // TEXT
  public addrNo: string; // VARCHAR(20)
  public ward: string; // VARCHAR(50)
  public city: string; // VARCHAR(50)
  public avgRating: number; // DECIMAL(2,1) (Default 0)
  public policy: string | null; // TEXT
  public phoneNo: string | null; // VARCHAR(10)
  public mapURL: string; // VARCHAR(255)
  public thumbnailURL: string; // VARCHAR(255)
  public isActive: boolean; // BOOLEAN (Default 1)
  public createdAt: Date; // DATETIME
  public updatedAt: Date; // DATETIME
}
