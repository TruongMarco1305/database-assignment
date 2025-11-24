import { Injectable, Logger } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { TableService } from 'src/database/table.service';
import { Owner } from '../entities';

@Injectable()
export class OwnerService extends TableService {
  protected readonly logger = new Logger(OwnerService.name);
  protected readonly tableName = 'owners';
  protected readonly createTableQuery = `
    CREATE TABLE ${this.tableName} (
        user_id VARCHAR(255) PRIMARY KEY,
        bankId VARCHAR(50) NOT NULL,
        bankName VARCHAR(100) NOT NULL,
        accountName VARCHAR(100) NOT NULL,
        accountNo VARCHAR(50) NOT NULL UNIQUE,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );
  `;

  constructor(databaseService: DatabaseService) {
    super(databaseService);
  }

  public async createNewOwner(userId: string) {
    const owner = new Owner(userId);
    await this.databaseService.execute(
      `INSERT INTO ${this.tableName} (user_id, bankId, bankName, accountName, accountNo)
       VALUES (?, ?, ?, ?, ?)`,
      [{ ...owner }],
    );
    return owner;
  }
}
