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

export class UserProfileDto {
  @ApiProperty({
    example: 'a1b2c3d4-e5f6-7890-1234-567890abcdef',
    description: 'User ID',
  })
  public id: string;

  @ApiProperty({ example: 'user@example.com', description: 'User email' })
  public email: string;

  @ApiProperty({ example: 'Van A', description: 'First name' })
  public firstName: string;

  @ApiProperty({ example: 'Nguyen', description: 'Last name' })
  public lastName: string;

  @ApiProperty({
    example: '+84987654321',
    description: 'Phone number',
    required: false,
    nullable: true,
  })
  public phoneNo: string | null;

  @ApiProperty({
    example: 'https://example.com/avatar.jpg',
    description: 'Avatar URL',
    required: false,
    nullable: true,
  })
  public avatarURL: string | null;

  @ApiProperty({ example: '1990-01-15', description: 'Date of birth' })
  public DoB: Date;

  @ApiProperty({ example: 1, description: 'Is active status' })
  public isActive: number;

  @ApiProperty({ example: 0, description: 'Is admin status' })
  public isAdmin: number;

  @ApiProperty({
    example: '2023-01-01T00:00:00.000Z',
    description: 'Created at',
  })
  public createdAt: Date;

  @ApiProperty({
    example: '2023-01-01T00:00:00.000Z',
    description: 'Updated at',
  })
  public updatedAt: Date;
}
