import { Global, Module } from '@nestjs/common';
import { DatabaseService } from './database.service';
import { Pool } from 'pg';
import { commonConfig, CommonConfigType } from 'src/config';
import { TableService } from './table.service';

@Global()
@Module({
  providers: [
    {
      provide: Pool,
      useFactory: (appCommonConfig: CommonConfigType) => {
        return new Pool({
          host: appCommonConfig.dbHost,
          port: appCommonConfig.dbPort,
          user: appCommonConfig.dbUser,
          password: appCommonConfig.dbPassword,
          connectionTimeoutMillis: 2000,
          maxLifetimeSeconds: 60,
        });
      },
      inject: [commonConfig.KEY],
    },
    DatabaseService,
  ],
  exports: [DatabaseService, TableService],
})
export class DatabaseModule {}
