import { Injectable } from '@nestjs/common';


@Injectable()
export class AuthService {

  constructor(
    private readonly tokenService: TokenService,
    private readonly userService: UserService,
  ) {}

  public async signup(signupDto: SignupDto) {
    const { firstName, lastName, email, password } = signupDto;
    const user = await this.userService.createUser(signupDto);
    const token = await this.tokenService.generateToken(user);
    return { token };
  }

  findAll() {
    return `This action returns all auth`;
  }

  findOne(id: number) {
    return `This action returns a #${id} auth`;
  }

  update(id: number, updateAuthDto: UpdateAuthDto) {
    return `This action updates a #${id} auth`;
  }

  remove(id: number) {
    return `This action removes a #${id} auth`;
  }
}
