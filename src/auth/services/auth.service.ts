import { Injectable } from '@nestjs/common';
import { TokenService } from './token.service';
import { UserService } from 'src/user/services/user.service';
import { LoginDto, OwnerSignupDto, SignupDto } from '../auth.dto';
import { ClientService, OwnerService } from 'src/user/services';

@Injectable()
export class AuthService {
  constructor(
    private readonly tokenService: TokenService,
    private readonly userService: UserService,
    private readonly clientService: ClientService,
    private readonly ownerService: OwnerService,
  ) {}

  public async signup(signupDto: SignupDto) {
    const userId = await this.userService.createUser(signupDto);
    await this.clientService.createNewClient(userId);
    const token = await this.tokenService.generateToken(userId);
    return { token };
  }

  public async login(loginDto: LoginDto) {
    const userId = await this.userService.validateLoginCredentials(loginDto);
    const token = await this.tokenService.generateToken(userId);
    return { token };
  }

  public async ownerSignup(userId: string, ownerSignupDto: OwnerSignupDto) {
    await this.ownerService.createNewOwner(userId, ownerSignupDto);
  }

  findOne(id: number) {
    return `This action returns a #${id} auth`;
  }

  remove(id: number) {
    return `This action removes a #${id} auth`;
  }
}
