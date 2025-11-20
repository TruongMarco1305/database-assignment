import { BaseEntity } from 'src/database/base.entity';
import { CreateUserInterface } from '../user.interface';
import bcrypt from 'bcrypt';

export class User extends BaseEntity {
  public email: string;
  public password: string;
  public firstName: string;
  public lastName: string;
  public phoneNo: string;
  public avatarURL: string;
  public DoB: Date;

  constructor(data: CreateUserInterface) {
    super();
    const { email, password, firstName, lastName, phoneNo, avatarURL, DoB } =
      data;
    this.email = email;
    this.password = bcrypt.hashSync(password, 10);
    this.firstName = firstName;
    this.lastName = lastName;
    this.phoneNo = phoneNo;
    this.avatarURL = avatarURL;
    this.DoB = DoB;
  }
}
