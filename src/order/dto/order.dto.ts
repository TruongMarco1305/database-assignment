import {
  IsNotEmpty,
  IsDateString,
  IsOptional,
  IsNumber,
  IsString,
  IsInt,
  Min,
  IsArray,
} from 'class-validator';

export class CreateOrderDto {
  @IsNotEmpty()
  @IsString()
  clientId: string;

  @IsNotEmpty()
  @IsString()
  locationId: string;

  @IsNotEmpty()
  @IsString()
  venueName: string;

  @IsNotEmpty()
  @IsDateString()
  startTime: string;

  @IsNotEmpty()
  @IsDateString()
  endTime: string;

  @IsOptional()
  @IsArray()
  amenityIds?: string[];

  @IsOptional()
  discountIds?: string[];
}

export class UpdateOrderDto {
  @IsOptional()
  @IsNumber()
  @Min(0)
  totalPrice?: number;

  @IsOptional()
  @IsInt()
  @Min(0)
  points?: number;

  @IsOptional()
  @IsString()
  status?: string; // 'PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED'
}

export class AddOrderAmenityDto {
  @IsNotEmpty()
  @IsString()
  orderId: string;

  @IsNotEmpty()
  @IsString()
  amenityId: string;
}

export class RemoveOrderAmenityDto {
  @IsNotEmpty()
  @IsString()
  orderId: string;

  @IsNotEmpty()
  @IsString()
  amenityId: string;
}
