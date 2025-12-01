export class User {
  public id: Buffer;
  public email: string;
  public password: string;
  public firstName: string;
  public lastName: string;
  public phoneNo: string | null;
  public avatarURL: string | null;
  public DoB: Date;
  public isActive: number;
  public isAdmin: number;
  public createdAt: Date;
  public updatedAt: Date;
}
