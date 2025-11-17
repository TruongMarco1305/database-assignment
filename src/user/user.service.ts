import { Injectable, Logger } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { TableService } from 'src/database/table.service';

@Injectable()
export class UserService extends TableService{
  protected readonly logger = new Logger(UserService.name);
  protected readonly tableName = 'users';
  protected readonly createTableQuery = `
    CREATE TABLE users (
      user_id SERIAL PRIMARY KEY,
      firstName VARCHAR(100) NOT NULL,
      lastName VARCHAR(100) NOT NULL,
      email VARCHAR(255) UNIQUE NOT NULL,
      password VARCHAR(255) NOT NULL,
      avatarUrl VARCHAR(512),
      DoB DATE,
      phoneNo VARCHAR(15),
      updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
  `;

  protected readonly postCreationQuery = `
    CREATE INDEX idx_users_email ON users(email);
  `;
  
  constructor(databaseService: DatabaseService) {
    super(databaseService);
  }

  public async createUser(userData:
}