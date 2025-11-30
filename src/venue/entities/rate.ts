export class Rate {
  public client_id: Buffer; // BINARY(16) (Primary Key & Foreign Key)
  public location_id: Buffer; // BINARY(16) (Primary Key & Foreign Key)
  public stars: number; // INT
  public comment: string | null; // TEXT
  public created_at: Date; // DATETIME
  public updated_at: Date; // DATETIME
}
