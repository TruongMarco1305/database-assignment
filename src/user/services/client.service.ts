import { Injectable, Logger } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { TableService } from 'src/database/table.service';
import { CREATE_CLIENT_TABLE_QUERY } from 'src/database/queries';
import { convertUUIDtoBinaryHex } from 'src/utils';

@Injectable()
export class ClientService extends TableService {
  protected readonly logger = new Logger(ClientService.name);
  protected readonly tableName = 'clients';
  protected readonly createTableQuery = CREATE_CLIENT_TABLE_QUERY;

  constructor(databaseService: DatabaseService) {
    super(databaseService);
  }

  public async createNewClient(userId: string) {
    const slug = `${Math.random().toString(36).substring(2, 8).toUpperCase()}`;
    await this.databaseService.execute(
      `Call Client_Insert(?, ?);`,
      [convertUUIDtoBinaryHex(userId), slug],
    );
  }
}
