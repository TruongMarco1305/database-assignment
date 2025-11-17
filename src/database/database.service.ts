import { Inject, Injectable, Logger, OnModuleDestroy } from '@nestjs/common';
import { Pool } from 'pg';

@Injectable()
export class DatabaseService implements OnModuleDestroy {
  private readonly logger: Logger = new Logger(DatabaseService.name);
  constructor(@Inject(Pool) private readonly pool: Pool) {}

  public async query<T>(text: string, params: any[] = []): Promise<T> {
    const start = Date.now();
    const res = await this.pool.query(text, params);
    const duration = Date.now() - start;
    this.logger.log('executed query', { text, duration, rows: res.rowCount });
    return res as unknown as T;
  }

  public async getClient() {
    const client = await this.pool.connect();
    const query = client.query;
    const release = client.release;

    let lastQueryArgs = null;

    // set a timeout of 5 seconds
    const timeout = setTimeout(() => {
      console.error('A client has been checked out for more than 5 seconds!');
      // Log the last query if it exists
      if (lastQueryArgs) {
        console.error('Last query was:', lastQueryArgs[0], lastQueryArgs[1]); // [0] is text, [1] is values
      }
    }, 5000);

    // monkey patch the query method to keep track
    client.query = (...args) => {
      lastQueryArgs = args; // <-- Store the query arguments
      return query.apply(client, args);
    };

    client.release = () => {
      clearTimeout(timeout);
      client.query = query;
      client.release = release;
      return release.apply(client);
    };

    return client;
  }

  async onModuleDestroy() {
    await this.pool.end();
  }
}
