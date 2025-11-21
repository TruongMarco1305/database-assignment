import { BaseEntity } from 'src/database/base.entity';
import { CreateUserInterface } from '../user.interface';

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
    const { email, password, firstName, lastName } = data;
    this.email = email;
    this.password = password;
    this.firstName = firstName;
    this.lastName = lastName;
  }
}
