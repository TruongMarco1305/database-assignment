import { ApiProperty } from '@nestjs/swagger';

export class SignupDto {
  @ApiProperty({
    example: 'user@example.com',
    description: 'User email address',
  })
  readonly email: string;

  @ApiProperty({ example: 'SecurePass123', description: 'User password' })
  readonly password: string;

  @ApiProperty({ example: 'Nguyen', description: 'User last name' })
  readonly lastName: string;

  @ApiProperty({ example: 'Van A', description: 'User first name' })
  readonly firstName: string;

  @ApiProperty({
    example: '1990-01-15',
    description: 'Date of birth (YYYY-MM-DD)',
  })
  readonly DoB: string;
}

export class LoginDto {
  @ApiProperty({
    example: 'user@example.com',
    description: 'User email address',
  })
  readonly email: string;

  @ApiProperty({ example: 'SecurePass123', description: 'User password' })
  readonly password: string;
}

export class GoogleLoginDto {
  @ApiProperty({
    example: 'eyJhbGciOiJSUzI1NiIsImtpZCI6...',
    description: 'Google OAuth token ID',
  })
  readonly tokenId: string;
}

export class OwnerSignupDto {
  @ApiProperty({ example: 'VCB', description: 'Bank ID code' })
  bankId: string;

  @ApiProperty({ example: 'Vietcombank', description: 'Bank name' })
  bankName: string;

  @ApiProperty({ example: 'NGUYEN VAN A', description: 'Account holder name' })
  accountName: string;

  @ApiProperty({ example: '1234567890', description: 'Bank account number' })
  accountNumber: string;
}
