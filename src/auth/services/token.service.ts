import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class TokenService {
  constructor(private jwtService: JwtService) {}

  public async generateToken(userId: string): Promise<string> {
    const payload = {
      user: userId,
      iat: Date.now(),
      exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 365,
    };
    return this.jwtService.signAsync(payload);
  }
}
