export class UpdateUserDto {
  public firstName?: string;
  public lastName?: string;
  public phoneNumber?: string;
  public avatar?: string;
  public dob?: string;
}

export class UpdateOwnerDto {
  public bankId: string;
  public bankName: string;
  public accountName: string;
  public accountNo: string;
}
