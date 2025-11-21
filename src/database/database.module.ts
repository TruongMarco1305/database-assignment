import { Global, Module } from '@nestjs/common';
import { DatabaseService } from './database.service';
import { commonConfig, CommonConfigType } from 'src/config';
import * as mysql from 'mysql2/promise';

@Global()
@Module({
  providers: [
    {
      provide: 'DATABASE_POOL',
      useFactory: (appCommonConfig: CommonConfigType) => {
        return mysql.createPool({
          host: appCommonConfig.dbHost,
          user: appCommonConfig.dbUser,
          database: appCommonConfig.dbName,
          password: appCommonConfig.dbPassword,
          port: appCommonConfig.dbPort,
          compress: false,
          waitForConnections: true,
          connectionLimit: 10,
          maxIdle: 10, // max idle connections, the default value is the same as `connectionLimit`
          idleTimeout: 60000, // idle connections timeout, in milliseconds, the default value 60000
          queueLimit: 0,
          enableKeepAlive: true,
          keepAliveInitialDelay: 0,
        });
      },
      inject: [commonConfig.KEY],
    },
    DatabaseService,
  ],
  exports: [DatabaseService],
})
export class DatabaseModule {}
