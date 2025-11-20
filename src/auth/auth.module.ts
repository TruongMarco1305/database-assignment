import { Module } from '@nestjs/common';
import { AuthService } from './services/auth.service';
import { AuthController } from './auth.controller';
import { DatabaseModule } from 'src/database/database.module';
import { TokenService } from './services';
import { UserModule } from 'src/user/user.module';

@Module({
  imports: [UserModule, DatabaseModule],
  controllers: [AuthController],
  providers: [AuthService, TokenService],
})
export class AuthModule {}
