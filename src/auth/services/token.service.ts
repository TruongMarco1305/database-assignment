import { Inject, Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Token } from '../entities/token.entity';
import { commonConfig, CommonConfigType } from 'src/config';
import * as dayjs from 'dayjs';

@Injectable()
export class TokenService {
  constructor(
    private jwtService: JwtService,
    @Inject(commonConfig.KEY) private appCommonConfig: CommonConfigType,
  ) {}

  public async generateToken(userId: string): Promise<string> {
    const payload = {
      user: userId,
      expiredAt: dayjs().add(1, 'year').toDate().toString(),
    };
    return this.jwtService.signAsync(payload);
  }

  public async verifyToken(token: string): Promise<Token> {
    const payload = await this.jwtService.verifyAsync<Token>(token, {
      secret: this.appCommonConfig.jwtSecret,
    });
    return payload;
  }
}
