import { ApiProperty } from '@nestjs/swagger';

export class UpdateUserDto {
  @ApiProperty({
    example: 'Van A',
    description: 'User first name',
    required: false,
  })
  public firstName?: string;

  @ApiProperty({
    example: 'Nguyen',
    description: 'User last name',
    required: false,
  })
  public lastName?: string;

  @ApiProperty({
    example: '+84987654321',
    description: 'Phone number',
    required: false,
  })
  public phoneNumber?: string;

  @ApiProperty({
    example: 'https://example.com/avatar.jpg',
    description: 'Avatar URL',
    required: false,
  })
  public avatar?: string;

  @ApiProperty({
    example: '1990-01-15',
    description: 'Date of birth (YYYY-MM-DD)',
    required: false,
  })
  public dob?: string;
}

export class UpdateOwnerDto {
  @ApiProperty({ example: 'VCB', description: 'Bank ID code' })
  public bankId: string;

  @ApiProperty({ example: 'Vietcombank', description: 'Bank name' })
  public bankName: string;

  @ApiProperty({ example: 'NGUYEN VAN A', description: 'Account holder name' })
  public accountName: string;

  @ApiProperty({ example: '1234567890', description: 'Bank account number' })
  public accountNo: string;
}
