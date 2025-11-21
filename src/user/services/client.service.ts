import { Injectable, Logger } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { TableService } from 'src/database/table.service';
import { Client } from '../entities';

@Injectable()
export class ClientService extends TableService {
  protected readonly logger = new Logger(ClientService.name);
  protected readonly tableName = 'clients';
  protected readonly createTableQuery = `
    CREATE TABLE ${this.tableName} (
        user_id VARCHAR(255) PRIMARY KEY,
        slug VARCHAR(10) NOT NULL UNIQUE,
        membership_points INT DEFAULT 0,
        membership_tier VARCHAR(20) DEFAULT 'BRONZE',
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );
  `;

  constructor(databaseService: DatabaseService) {
    super(databaseService);
  }

  public async createNewClient(userId: string) {
    const client = new Client(userId);
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
