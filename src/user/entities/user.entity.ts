import { CreateUserInterface } from '../user.interface';

export class User {
  public id: string;
  public email: string;
  public password: string;
  public firstName: string;
  public lastName: string;
  public phoneNo: string;
  public avatarURL: string;
  public DoB: Date;
  public createdAt: Date;
  public updatedAt: Date;

  constructor(data: CreateUserInterface) {
    const { email, password, firstName, lastName, DoB } = data;
    this.email = email;
    this.password = password;
    this.firstName = firstName;
    this.lastName = lastName;
    this.DoB = new Date(DoB);
  }
}
