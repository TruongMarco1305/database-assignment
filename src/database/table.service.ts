import { Injectable, OnModuleInit, Logger } from '@nestjs/common';
import { DatabaseService } from './database.service';

@Injectable()
export abstract class TableService implements OnModuleInit {
  // Logger must be instantiated in the subclass to get the correct context
  protected abstract readonly logger: Logger;

  /**
   * The name of the table to check for.
   */
  protected abstract readonly tableName: string;

  /**
   * The SQL query to create the table if it doesn't exist.
   */
  protected abstract readonly createTableQuery: string;

  /**
   * An optional SQL query to run *after* table creation,
   * such as creating indexes or foreign keys.
   */
  protected readonly postCreationQuery?: string;

  // Inject the pool in the base constructor
  constructor(private readonly databaseService: DatabaseService) {}

  /**
   * This method is automatically called by NestJS
   * when the module containing this service is initialized.
   */
  async onModuleInit() {
    this.logger.log(`Looking for table "${this.tableName}"...`);
    await this.checkAndCreateTable();
  }

  /**
   * A generic method to check for and create a table.
   * It uses the abstract properties defined by the subclass.
   */
  private async checkAndCreateTable() {
    const client = await this.databaseService.getClient();
    try {
      // Query to check if the table exists in the public schema
      const checkTableQuery = `
        SELECT EXISTS (
          SELECT FROM information_schema.tables 
          WHERE  table_schema = 'public'
          AND    table_name   = $1
        );
      `;

      const res = await client.query(checkTableQuery, [this.tableName]);
      const tableExists = res.rows[0].exists;

      if (!tableExists) {
        // --- Table does not exist, so create it ---
        this.logger.warn(
          `Table "${this.tableName}" does not exist. Creating it now...`,
        );

        // Run the creation query defined by the subclass
        await client.query(this.createTableQuery);
        this.logger.log(`Successfully created "${this.tableName}" table.`);

        // Run post-creation query if it exists
        if (this.postCreationQuery) {
          this.logger.log(
            `Running post-creation query for "${this.tableName}"...`,
          );
          await client.query(this.postCreationQuery);
          this.logger.log(
            `Successfully ran post-creation query for "${this.tableName}".`,
          );
        }
      } else {
        // --- Table already exists ---
        this.logger.log(
          `Table "${this.tableName}" already exists. No action taken.`,
        );
      }
    } catch (error) {
      this.logger.error(
        `Error during table check/creation for "${this.tableName}":`,
        error.stack,
      );
      throw error;
    } finally {
      client.release();
    }
  }
}
