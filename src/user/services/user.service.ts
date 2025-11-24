import { BadRequestException, Injectable, Logger } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { TableService } from 'src/database/table.service';
import { CreateUserInterface } from '../user.interface';
import { User } from '../entities/user.entity';
import { LoginDto } from 'src/auth/auth.dto';
import * as bcrypt from 'bcrypt';
import {
  CREATE_USER_EMAIL_INDEX_QUERY,
  CREATE_USER_TABLE_QUERY,
} from 'src/database/queries';

@Injectable()
export class UserService extends TableService {
  protected readonly logger = new Logger(UserService.name);
  protected readonly tableName = 'users';
  protected readonly createTableQuery = CREATE_USER_TABLE_QUERY;

  protected readonly postCreationQuery = CREATE_USER_EMAIL_INDEX_QUERY;

  constructor(databaseService: DatabaseService) {
    super(databaseService);
  }

  public async createUser(userData: CreateUserInterface) {
    const hashedPassword = await bcrypt.hash(userData.password, 10);
    const user = new User({ ...userData, password: hashedPassword });
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
