import { Injectable, Logger } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { TableService } from 'src/database/table.service';
import { Client } from '../entities';
import { CREATE_CLIENT_TABLE_QUERY } from 'src/database/queries';

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
    const client = new Client(userId, slug, 0, 'BRONZE');
    await this.databaseService.execute(
      `INSERT INTO ${this.tableName} (user_id, slug, membership_points, membership_tier)
       VALUES (?, ?, ?, ?)`,
      [
        client.userId,
        client.slug,
        client.membership_points,
        client.membership_tier,
      ],
    );
    return client;
  }
}
