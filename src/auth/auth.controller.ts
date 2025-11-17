import { Controller, Post, Body, Param, Delete } from '@nestjs/common';
import { AuthService } from './services/auth.service';
import { LoginDto } from './auth.dto';

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

  @Post('/google-login')
  public async googleLogin(@Body() googleLoginDto: GoogleLoginDto) {
    return this.authService.googleLogin(googleLoginDto);
  }

  @Delete('/logout')
  public async logout(@Param('id') id: string) {
    return this.authService.logout(+id);
  }
}
