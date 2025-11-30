export class Favor {
  public client_id: Buffer; // BINARY(16) (Primary Key & Foreign Key)
  public location_id: Buffer; // BINARY(16) (Primary Key & Foreign Key)
  public created_at: Date; // DATETIME
}
