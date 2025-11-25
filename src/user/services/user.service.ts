import { BadRequestException, Injectable, Logger } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { TableService } from 'src/database/table.service';
import { CreateUserInterface } from '../user.interface';
import { User } from '../entities/user.entity';
import { LoginDto } from 'src/auth/auth.dto';
import * as bcrypt from 'bcrypt';
import { CREATE_USER_TABLE_QUERY } from 'src/database/queries';

@Injectable()
export class UserService extends TableService {
  protected readonly logger = new Logger(UserService.name);
  protected readonly tableName = 'users';
  protected readonly createTableQuery = CREATE_USER_TABLE_QUERY;

  constructor(databaseService: DatabaseService) {
    super(databaseService);
  }

  public async createUser(userData: CreateUserInterface) {
    const hashedPassword = bcrypt.hashSync(userData.password, 10);
    const user = new User({
      ...userData,
      password: hashedPassword,
    });
    await this.databaseService.execute(
      `INSERT INTO ${this.tableName} (id, email, password, firstName, lastName, DoB)
       VALUES (UUID_TO_BIN(UUID()), ?, ?, ?, ?, ?)`,
      [user.email, user.password, user.firstName, user.lastName, user.DoB],
    );
    return user;
  }

  public async validateLoginCredentials(loginDto: LoginDto) {
    const { email, password } = loginDto;
    const result = await this.databaseService.execute<any>(
      `SELECT * FROM ${this.tableName} WHERE email = ?`,
      [email],
    );
    if (result.length === 0) {
      throw new BadRequestException('User not found');
    }
    const user = result[0];
    const validatePassword = password === user.password;
    if (!validatePassword) {
      throw new BadRequestException('Invalid credentials');
    }
    return user;
  }
}
