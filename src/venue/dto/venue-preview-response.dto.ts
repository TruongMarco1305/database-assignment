import { ApiProperty } from '@nestjs/swagger';

export class VenuePreviewResponseDto {
  @ApiProperty({
    example: 'Conference Room A',
    description: 'Venue name',
  })
  venue_name: string;

  @ApiProperty({
    example: '3',
    description: 'Floor number',
  })
  floor: string;

  @ApiProperty({
    example: 50.5,
    description: 'Area in square meters',
  })
  area: number;

  @ApiProperty({
    example: 150000,
    description: 'Price per hour in VND',
  })
  pricePerHour: number;

  @ApiProperty({
    example: 'aaaa1111-aaaa-aaaa-aaaa-aaaaaaaa0001',
    description: 'Venue type ID',
  })
  venueType_id: string;

  @ApiProperty({
    example: 'Minimalist',
    description: 'Theme name',
  })
  theme_name: string;

  @ApiProperty({
    example: 10,
    description: 'Minimum capacity',
  })
  minCapacity: number;

  @ApiProperty({
    example: 50,
    description: 'Maximum capacity',
  })
  maxCapacity: number;

  @ApiProperty({
    example: '30303030-3030-3030-3030-303030303002',
    description: 'Location UUID',
  })
  location_id_uuid: string;
}
