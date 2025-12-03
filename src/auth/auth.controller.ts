import { Controller, Post, Body, UseGuards, Patch } from '@nestjs/common';
import { AuthService } from './services/auth.service';
import { LoginDto, OwnerSignupDto, SignupDto } from './auth.dto';
import { AuthGuard } from './guards/user.guard';
import { User } from './decorators';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('/signup')
  public async signup(@Body() signupDto: SignupDto) {
    return this.authService.signup(signupDto);
  }

  @Post('/owner/signup')
  @UseGuards(AuthGuard)
  public async ownerSignup(
    @User() user: Express.User,
    @Body() ownerSignupDto: OwnerSignupDto,
  ) {
    return this.authService.ownerSignup(user.userId, ownerSignupDto);
  }

  @Post('/login')
  public async login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }

  @Patch('/switch/owner')
  @UseGuards(AuthGuard)
  public async switchToOwner(@User() user: Express.User) {
    return this.authService.switchToOwner(user.userId);
  }
}
