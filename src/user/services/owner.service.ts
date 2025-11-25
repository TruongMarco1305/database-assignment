import { Injectable, Logger } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { TableService } from 'src/database/table.service';
import { Owner } from '../entities';
import { CREATE_OWNER_TABLE_QUERY } from 'src/database/queries';

@Injectable()
export class OwnerService extends TableService {
  protected readonly logger = new Logger(OwnerService.name);
  protected readonly tableName = 'owners';
  protected readonly createTableQuery = CREATE_OWNER_TABLE_QUERY;

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
