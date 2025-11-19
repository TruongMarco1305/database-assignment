import { Injectable, OnModuleInit, Logger } from '@nestjs/common';
import { DatabaseService } from './database.service';
import { RowDataPacket } from 'mysql2/promise';

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

  // Inject the DatabaseService which holds the Pool
  constructor(private readonly databaseService: DatabaseService) {}

  /**
   * This method is automatically called by NestJS
   * when the module containing this service is initialized.
   */
  async onModuleInit() {
    this.logger.log(`Looking for table "${this.tableName}"...`);
    await this.checkAndCreateTable();
  }

  // --- Core Table Management Logic ---

  /**
   * A generic method to check for and create a table.
   * It uses the abstract properties defined by the subclass.
   */
  private async checkAndCreateTable() {
    // Get a dedicated connection from the pool (required for sequential operations)
    const connection = await this.databaseService.getConnection();
    try {
      // 1. Query to check if the table exists
      // In MySQL, we query information_schema.tables using the placeholder '?'
      const checkTableQuery = `
        SELECT COUNT(*) AS tableCount
        FROM information_schema.tables
        WHERE table_schema = DATABASE()
        AND table_name = ?;
      `;

      // connection.execute returns [rows, fields]
      const [rows] = await connection.execute(checkTableQuery, [
        this.tableName,
      ]);

      // MySQL results are RowDataPacket arrays. We check the tableCount property.
      const tableExists = (rows as RowDataPacket[])[0]['tableCount'] > 0;

      if (!tableExists) {
        // --- Table does not exist, so create it ---
        this.logger.warn(
          `Table "${this.tableName}" does not exist. Creating it now...`,
        );

        // Run the creation query defined by the subclass
        await connection.execute(this.createTableQuery);
        this.logger.log(`Successfully created "${this.tableName}" table.`);

        // Run post-creation query if it exists
        if (this.postCreationQuery) {
          this.logger.log(
            `Running post-creation query for "${this.tableName}"...`,
          );
          await connection.execute(this.postCreationQuery);
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
        (error as Error).stack,
      );
      throw error;
    } finally {
      // IMPORTANT: Release the connection back to the pool
      connection.release();
    }
  }
}
