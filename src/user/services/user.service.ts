import {
  BadRequestException,
  ConflictException,
  Injectable,
  Logger,
} from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { TableService } from 'src/database/table.service';
import { CreateUserInterface } from '../user.interface';
import { LoginDto } from 'src/auth/auth.dto';
import * as bcrypt from 'bcrypt';
import { CREATE_USER_TABLE_QUERY } from 'src/database/queries';
import { v4 as uuidv4 } from 'uuid';
import { convertBinaryHexToUUID, convertUUIDtoBinaryHex } from 'src/utils';
import { User } from '../entities';
import { UpdateUserDto } from '../user.dto';

@Injectable()
export class UserService extends TableService {
  protected readonly logger = new Logger(UserService.name);
  protected readonly tableName = 'users';
  protected readonly createTableQuery = CREATE_USER_TABLE_QUERY;

  constructor(databaseService: DatabaseService) {
    super(databaseService);
  }

  public async createUser(userData: CreateUserInterface) {
    const { email, password, DoB, firstName, lastName } = userData;
    const hashedPassword = bcrypt.hashSync(password, 10);
    const userId = uuidv4();
    await this.databaseService.execute(
      `INSERT INTO ${this.tableName} (id, email, password, firstName, lastName, DoB)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [
        convertUUIDtoBinaryHex(userId),
        email,
        hashedPassword,
        firstName,
        lastName,
        new Date(DoB),
      ],
      {
        ER_DUP_ENTRY: () => {
          throw new ConflictException('Email already exist');
        },
      },
    );
    return userId;
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
    const validatePassword = bcrypt.compareSync(password, user.password);
    if (!validatePassword) {
      throw new BadRequestException('Invalid credentials');
    }
    return convertBinaryHexToUUID(user.id);
  }

  public async findUserById(userId: string): Promise<User> {
    const result = await this.databaseService.execute<User>(
      `SELECT * FROM ${this.tableName} WHERE id = ?`,
      [convertUUIDtoBinaryHex(userId)],
    );
    if (result.length === 0) {
      throw new BadRequestException('User not found');
    }
    return result[0];
  }

  public async updateUser(
    userId: string,
    updateUserDto: UpdateUserDto,
  ): Promise<void> {
    const {
      firstName = null,
      lastName = null,
      phoneNumber = null,
      avatar = null,
      dob = null,
    } = updateUserDto;
    await this.databaseService.execute(
      `UPDATE ${this.tableName}
      SET
        firstName        = COALESCE(?, firstName),
        lastName = COALESCE(?, lastName),
        phoneNo      = COALESCE(?, phoneNo),
        avatarURL        = COALESCE(?, avatarURL),
        DoB        = COALESCE(?, DoB)
      WHERE id = ?
      `,
      [
        firstName,
        lastName,
        phoneNumber,
        avatar,
        dob,
        convertUUIDtoBinaryHex(userId),
      ],
    );
  }
}
