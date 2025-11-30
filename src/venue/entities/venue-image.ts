export class VenueImage {
  public image_id: Buffer; // BINARY(16) (Primary Key)
  public location_id: Buffer; // BINARY(16) (Foreign Key, part of composite key)
  public venueName: string; // VARCHAR(100) (Foreign Key, part of composite key)
  public locationImgURL: string; // VARCHAR(255)
}
