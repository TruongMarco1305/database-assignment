import { Controller, Post, Body, UseGuards, Patch } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { AuthService } from './services/auth.service';
import { LoginDto, OwnerSignupDto, SignupDto } from './auth.dto';
import { AuthGuard } from './guards/user.guard';
import { User } from './decorators';

@ApiTags('Authentication')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('/signup')
  @ApiOperation({ summary: 'Register a new client user' })
  @ApiResponse({ status: 201, description: 'User successfully registered' })
  @ApiResponse({ status: 400, description: 'Invalid input data' })
  public async signup(@Body() signupDto: SignupDto) {
    return this.authService.signup(signupDto);
  }

  @Post('/owner/signup')
  @UseGuards(AuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Upgrade client account to owner account' })
  @ApiResponse({
    status: 201,
    description: 'Owner account created successfully',
  })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  @ApiResponse({ status: 400, description: 'Invalid input data' })
  public async ownerSignup(
    @User() user: Express.User,
    @Body() ownerSignupDto: OwnerSignupDto,
  ) {
    return this.authService.ownerSignup(user.userId, ownerSignupDto);
  }

  @Post('/login')
  @ApiOperation({ summary: 'Login with email and password' })
  @ApiResponse({ status: 200, description: 'Login successful' })
  @ApiResponse({ status: 401, description: 'Invalid credentials' })
  public async login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }

  @Patch('/switch/owner')
  @UseGuards(AuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Switch user role to owner' })
  @ApiResponse({
    status: 200,
    description: 'Successfully switched to owner role',
  })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  @ApiResponse({ status: 404, description: 'Owner account not found' })
  public async switchToOwner(@User() user: Express.User) {
    return this.authService.switchToOwner(user.userId);
  }
}
