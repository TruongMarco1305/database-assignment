import { Controller, Post, Body } from '@nestjs/common';
import { AuthService } from './services/auth.service';
import { LoginDto, SignupDto } from './auth.dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('/signup')
  public async signup(@Body() signupDto: SignupDto) {
    return this.authService.signup(signupDto);
  }

  @Post('/login')
  public async login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }
}
