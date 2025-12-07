import { ApiProperty } from '@nestjs/swagger';

export class CreateOrderResponseDto {
  @ApiProperty({
    example: 'order-uuid-here',
    description: 'Created order ID',
  })
  _id: string;

  @ApiProperty({
    example: '2024-12-07T11:30:00Z',
    description: 'Order expiration time (15 minutes from creation)',
  })
  expiredTime: Date;
}

export class OrderMetadataResponseDto {
  @ApiProperty({
    description: 'Available discounts for the venue and time slot',
    type: 'array',
    items: {
      type: 'object',
    },
  })
  discounts: any[];

  @ApiProperty({
    description: 'Available amenities for the venue and time slot',
    type: 'array',
    items: {
      type: 'object',
    },
  })
  amenities: any[];
}
