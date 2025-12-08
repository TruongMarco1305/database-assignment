import { ApiProperty } from '@nestjs/swagger';
import { IsInt, Min, Max, IsNotEmpty } from 'class-validator';

export class AdminOwnerFeesQueryDto {
  @ApiProperty({
    example: 12,
    description: 'Month to query (1-12)',
    minimum: 1,
    maximum: 12,
  })
  @IsNotEmpty()
  @IsInt()
  @Min(1)
  @Max(12)
  month: number;

  @ApiProperty({
    example: 2024,
    description: 'Year to query',
    minimum: 2000,
  })
  @IsNotEmpty()
  @IsInt()
  @Min(2000)
  year: number;
}

export class AdminOwnerFeesResponseDto {
  @ApiProperty({
    example: '30303030-3030-3030-3030-303030303001',
    description: 'Owner user ID',
  })
  Owner_ID: string;

  @ApiProperty({
    example: 'John Doe',
    description: 'Owner account name',
  })
  Owner_Name: string;

  @ApiProperty({
    example: '1234567890',
    description: 'Bank account number',
  })
  Bank_Account: string;

  @ApiProperty({
    example: 5,
    description: 'Number of active locations',
  })
  Active_Locations: number;

  @ApiProperty({
    example: 50000000,
    description: 'Total gross revenue in VND',
  })
  Gross_Revenue: number;

  @ApiProperty({
    example: 2500000,
    description: 'Total platform service fee in VND',
  })
  Total_Service_Fee: number;

  @ApiProperty({
    example: 47500000,
    description: 'Net income (revenue minus service fee) in VND',
  })
  Net_Income: number;
}
