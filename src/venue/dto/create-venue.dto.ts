import {
  IsNotEmpty,
  IsUrl,
  IsOptional,
  IsNumber,
  IsString,
  Min,
  Max,
  IsInt,
  IsDateString,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateLocationDto {
  @ApiProperty({
    example: 'Sky Garden Event Space',
    description: 'Location name',
  })
  @IsNotEmpty()
  @IsString()
  name: string;

  @ApiProperty({
    example: 'Modern event space with panoramic city views',
    description: 'Location description',
    required: false,
  })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiProperty({
    example: '123 Nguyen Hue',
    description: 'Street address number',
  })
  @IsNotEmpty()
  @IsString()
  addrNo: string;

  @ApiProperty({ example: 'Ben Nghe', description: 'Ward/District' })
  @IsNotEmpty()
  @IsString()
  ward: string;

  @ApiProperty({ example: 'Ho Chi Minh City', description: 'City name' })
  @IsNotEmpty()
  @IsString()
  city: string;

  @ApiProperty({
    example: 'No smoking. Pets not allowed.',
    description: 'Location policies',
    required: false,
  })
  @IsOptional()
  @IsString()
  policy?: string;

  @ApiProperty({
    example: '+84281234567',
    description: 'Contact phone number',
    required: false,
  })
  @IsOptional()
  @IsString()
  phoneNo?: string;

  @ApiProperty({
    example: 'https://maps.google.com/?q=10.7769,106.7009',
    description: 'Google Maps URL',
  })
  @IsUrl()
  @IsNotEmpty()
  mapURL: string;

  @ApiProperty({
    example: 'https://example.com/thumbnail.jpg',
    description: 'Thumbnail image URL',
  })
  @IsUrl()
  @IsNotEmpty()
  thumbnailURL: string;
}

export class UpdateLocationDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsString()
  addrNo?: string;

  @IsOptional()
  @IsString()
  ward?: string;

  @IsOptional()
  @IsString()
  city?: string;

  @IsOptional()
  @IsString()
  policy?: string;

  @IsOptional()
  @IsString()
  phoneNo?: string;

  @IsOptional()
  @IsUrl()
  mapURL?: string;

  @IsOptional()
  @IsUrl()
  thumbnailURL?: string;

  @IsOptional()
  isActive?: boolean;
}

export class CreateVenueTypeDto {
  @IsNotEmpty()
  @IsString()
  name: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsNotEmpty()
  @IsInt()
  @Min(1)
  minCapacity: number;

  @IsNotEmpty()
  @IsInt()
  @Min(1)
  maxCapacity: number;
}

export class UpdateVenueTypeDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  minCapacity?: number;

  @IsOptional()
  @IsInt()
  @Min(1)
  maxCapacity?: number;
}

export class CreateVenueDto {
  @IsNotEmpty()
  @IsString()
  locationId: string;

  @IsNotEmpty()
  @IsString()
  name: string;

  @IsNotEmpty()
  @IsString()
  venueTypeId: string;

  @IsNotEmpty()
  @IsString()
  floor: string;

  @IsNotEmpty()
  @IsNumber()
  @Min(0.1)
  area: number;

  @IsNotEmpty()
  @IsNumber()
  @Min(0.01)
  pricePerHour: number;

  @IsOptional()
  images: string[];
}

export class UpdateVenueDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  typeId?: string;

  @IsOptional()
  @IsString()
  floor?: string;

  @IsOptional()
  @IsNumber()
  @Min(0.1)
  area?: number;

  @IsOptional()
  @IsNumber()
  @Min(0.01)
  pricePerHour?: number;

  @IsOptional()
  isActive?: boolean;
}

export class CreateVenueImageDto {
  @IsNotEmpty()
  @IsString()
  locationId: string;

  @IsNotEmpty()
  @IsString()
  venueName: string;

  @IsUrl()
  @IsNotEmpty()
  url: string;
}

export class CreateRateDto {
  @IsNotEmpty()
  @IsString()
  clientId: string;

  @IsNotEmpty()
  @IsString()
  locationId: string;

  @IsNotEmpty()
  @IsInt()
  @Min(1)
  @Max(5)
  stars: number;

  @IsOptional()
  @IsString()
  comment?: string;
}

export class UpdateRateDto {
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(5)
  stars?: number;

  @IsOptional()
  @IsString()
  comment?: string;
}

export class CreateFavorDto {
  @IsNotEmpty()
  @IsString()
  clientId: string;

  @IsNotEmpty()
  @IsString()
  locationId: string;
}

export class CreateAmenityDto {
  @IsNotEmpty()
  @IsString()
  locationId: string;

  @IsNotEmpty()
  @IsString()
  category: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsNotEmpty()
  @IsNumber()
  @Min(0)
  price: number;

  @IsOptional()
  @IsString()
  compatibleSize?: string;
}

export class UpdateAmenityDto {
  @IsOptional()
  @IsString()
  category?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsNumber()
  @Min(0)
  price?: number;

  @IsOptional()
  @IsString()
  compatibleSize?: string;

  @IsOptional()
  isActive?: boolean;
}

export class SearchLocationsDto {
  @IsNotEmpty()
  @IsString()
  city: string;

  @IsOptional()
  @IsDateString()
  startTime?: string;

  @IsOptional()
  @IsDateString()
  endTime?: string;

  @IsOptional()
  @IsNumber()
  @Min(0)
  minPrice?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  maxPrice?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(5)
  minAvgRating?: number;

  @IsOptional()
  @IsString()
  theme?: string;

  @IsOptional()
  @IsString()
  size?: string; // 'Small', 'Medium', 'Large'

  @IsOptional()
  @IsString()
  amenityCategory?: string;

  @IsOptional()
  @IsString()
  sort?: string; // 'PRICE_ASC', 'PRICE_DESC', 'RATING', 'AREA_ASC', 'AREA_DESC'
}
