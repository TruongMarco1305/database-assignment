import {
  Inject,
  Injectable,
  InternalServerErrorException,
  Logger,
  OnModuleDestroy,
} from '@nestjs/common';
import dayjs from 'dayjs';
import { Pool, RowDataPacket } from 'mysql2/promise';

// Define the injection token for the Pool
export const DATABASE_POOL = 'DATABASE_POOL';

// Type alias for common query results
export type QueryResult<T> = (T & RowDataPacket)[];
@Injectable()
export class DatabaseService implements OnModuleDestroy {
  private readonly logger: Logger = new Logger(DatabaseService.name);
  constructor(
    @Inject(DATABASE_POOL)
    private readonly pool: Pool,
  ) {}

  public async execute<T>(
    sql: string,
    values?: any[],
  ): Promise<QueryResult<T>> {
    try {
      const startTime = dayjs().toDate();
      const [results] = await this.pool.execute(sql, values);
      const endTime = dayjs().toDate();
      const duration = dayjs(endTime).diff(dayjs(startTime), 'millisecond');
      this.logger.log(`Executed query in ${duration} ms: ${sql}`);
      return results as QueryResult<T>;
    } catch (error) {
      this.logger.error('Database query failed:', error);
      // Re-throw a custom error to maintain service layer abstraction
      throw new InternalServerErrorException('Database operation failed.');
    }
  }

  /**
   * Provides a dedicated connection instance for complex operations like transactions.
   * The user MUST call connection.release() in a finally block.
   */
  async getConnection() {
    return this.pool.getConnection();
  }

  async onModuleDestroy() {
    await this.pool.end();
    this.logger.log('Database pool has been closed.');
  }
}
