import { v4 as uuidv4 } from 'uuid';

export class BaseEntity {
  public id: string;
  public createdAt: Date;
  public updatedAt: Date;

  constructor() {
    this.id = uuidv4();
    this.createdAt = new Date();
    this.updatedAt = new Date();
  }
}
