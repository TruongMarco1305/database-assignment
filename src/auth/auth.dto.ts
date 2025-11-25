export class SignupDto {
  readonly email: string;
  readonly password: string;
  readonly lastName: string;
  readonly firstName: string;
  readonly DoB: string;
}

export class LoginDto {
  readonly email: string;
  readonly password: string;
}

export class GoogleLoginDto {
  readonly tokenId: string;
}
