import { Body, Controller, Get, Patch, UseGuards } from '@nestjs/common';
import { UserService } from './services/user.service';
import { UpdateOwnerDto, UpdateUserDto } from './user.dto';
import { AuthGuard, OwnerGuard } from 'src/auth/guards';
import { User } from 'src/auth/decorators';
import { OwnerService } from './services';

@Controller('user')
export class UserController {
  constructor(
    private readonly userService: UserService,
    private readonly ownerService: OwnerService,
  ) {}

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

  @Patch('/owner/me')
  @UseGuards(OwnerGuard)
  updateOwner(@User() user: Express.User, @Body() dto: UpdateOwnerDto) {
    return this.ownerService.updateOwner(user.userId, dto);
  }
}
