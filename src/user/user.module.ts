import { Module } from '@nestjs/common';
import { UserService } from './services/user.service';
import { UserController } from './user.controller';
import { DatabaseModule } from 'src/database/database.module';
import { ClientService, OwnerService } from './services';

@Module({
  imports: [DatabaseModule],
  controllers: [UserController],
  providers: [UserService, ClientService, OwnerService],
  exports: [UserService, ClientService, OwnerService],
})
export class UserModule {}
