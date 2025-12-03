import { Body, Controller, Get, Patch, UseGuards } from '@nestjs/common';
import { UserService } from './services/user.service';
import { UpdateUserDto } from './user.dto';
import { AuthGuard } from 'src/auth/guards';
import { User } from 'src/auth/decorators';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Patch('/me')
  @UseGuards(AuthGuard)
  update(@User() user: Express.User, @Body() updateUserDto: UpdateUserDto) {
    return this.userService.updateUser(user.userId, updateUserDto);
  }

  @Get('/me')
  @UseGuards(AuthGuard)
  getProfile(@User() user: Express.User) {
    console.log(user);
    if (user.role === 'client') {
      return this.userService.findUserById(user.userId);
    } else {
      return this.userService.findOwnerByUserId(user.userId);
    }
  }
}
