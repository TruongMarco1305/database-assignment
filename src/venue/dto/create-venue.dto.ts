import {
  IsNotEmpty,
  IsUrl,
  IsOptional,
  IsNumber,
  IsString,
  Min,
  Max,
  IsInt,
} from 'class-validator';

export class CreateLocationDto {
  @IsNotEmpty()
  @IsString()
  name: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsNotEmpty()
  @IsString()
  addrNo: string;

  @IsNotEmpty()
  @IsString()
  ward: string;

  @IsNotEmpty()
  @IsString()
  city: string;

  @IsOptional()
  @IsString()
  policy?: string;

  @IsOptional()
  @IsString()
  phoneNo?: string;

  @IsUrl()
  @IsNotEmpty()
  mapURL: string;

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
}

export class UpdateVenueDto {
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
