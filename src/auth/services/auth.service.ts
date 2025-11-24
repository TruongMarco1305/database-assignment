import { Injectable } from '@nestjs/common';
import { TokenService } from './token.service';
import { UserService } from 'src/user/services/user.service';
import { LoginDto, SignupDto } from '../auth.dto';
import { ClientService } from 'src/user/services';

@Injectable()
export class AuthService {
  constructor(
    private readonly tokenService: TokenService,
    private readonly userService: UserService,
    private readonly clientService: ClientService,
  ) {}

  public async signup(signupDto: SignupDto) {
    const user = await this.userService.createUser(signupDto);
    await this.clientService.createNewClient(user.id);
    const token = await this.tokenService.generateToken(user.id);
    return { token };
  }

  public async login(loginDto: LoginDto) {
    const user = await this.userService.validateLoginCredentials(loginDto);
    const token = await this.tokenService.generateToken(user.id);
    return { token };
  }

  findOne(id: number) {
    return `This action returns a #${id} auth`;
  }

  remove(id: number) {
    return `This action removes a #${id} auth`;
  }
}
