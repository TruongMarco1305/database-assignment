import { BadRequestException, Injectable, Logger } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { TableService } from 'src/database/table.service';
import { CreateUserInterface } from '../user.interface';
import { User } from '../entities/user.entity';
import { LoginDto } from 'src/auth/auth.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UserService extends TableService {
  protected readonly logger = new Logger(UserService.name);
  protected readonly tableName = 'users';
  protected readonly createTableQuery = `
    CREATE TABLE ${this.tableName} (
        id VARCHAR(255) PRIMARY KEY,
        email VARCHAR(100) NOT NULL UNIQUE CHECK (email LIKE '%_@__%.__%'),
        password VARCHAR(255) NOT NULL,
        firstName VARCHAR(50),
        lastName VARCHAR(50),
        phoneNo VARCHAR(15) CHECK (LENGTH(phoneNo) = 10),
        avatarURL VARCHAR(255),
        DoB DATE,
        createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
    );
  `;

  protected readonly postCreationQuery = `
    CREATE INDEX idx_users_email ON users(email);
  `;

  constructor(databaseService: DatabaseService) {
    super(databaseService);
  }

  public async createUser(userData: CreateUserInterface) {
    const user = new User(userData);
    await this.databaseService.execute(
      `INSERT INTO ${this.tableName} (id, email, password, firstName, lastName)
       VALUES (?, ?, ?, ?, ?)`,
      [user.id, user.email, user.password, user.firstName, user.lastName],
    );
    return user;
  }

  public async validateLoginCredentials(loginDto: LoginDto) {
    const { email, password } = loginDto;
    const result = await this.databaseService.execute<User>(
      `SELECT * FROM ${this.tableName} WHERE email = ?`,
      [email],
    );
    if (result.length === 0) {
      throw new BadRequestException('User not found');
    }
    const user = result[0];
    const validatePassword = await bcrypt.compare(password, user.password);
    if (!validatePassword) {
      throw new BadRequestException('Invalid credentials');
    }
    return user;
  }
}
