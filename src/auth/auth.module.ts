import { Module } from '@nestjs/common';
import { AuthService } from './services/auth.service';
import { AuthController } from './auth.controller';
import { DatabaseModule } from 'src/database/database.module';
import { TokenService } from './services';

@Module({
  imports: [DatabaseModule],
  controllers: [AuthController],
  providers: [AuthService, TokenService],
})
export class AuthModule {}
