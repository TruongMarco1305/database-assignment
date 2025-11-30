import { IsNotEmpty, IsUrl, IsOptional } from 'class-validator';

export class CreateLocationDto {
  @IsNotEmpty()
  name: string;

  @IsOptional()
  description?: string;

  @IsNotEmpty()
  addrNo: string;

  @IsNotEmpty()
  ward: string;

  @IsNotEmpty()
  city: string;

  @IsOptional()
  policy?: string;

  @IsNotEmpty()
  phoneNo?: string;

  @IsUrl()
  @IsNotEmpty()
  mapURL: string;

  @IsUrl()
  @IsNotEmpty()
  thumbnailURL: string;
}

export class CreateVenueTypeDto {
  @IsNotEmpty()
  name: string; // VARCHAR(50) UNIQUE

  @IsOptional()
  description?: string; // TEXT

  @IsNotEmpty()
  minCapacity: number; // INT CHECK (minCapacity > 0)

  @IsNotEmpty()
  maxCapacity: number; // INT CHECK (maxCapacity > 0)

  @IsNotEmpty()
  area: number; // DECIMAL(10, 1) CHECK (area > 0)
}

export class CreateVenueDto {
  @IsNotEmpty()
  locationId: string; // The ID of the parent Location

  @IsNotEmpty()
  name: string; // VARCHAR(100) - part of composite key

  @IsNotEmpty()
  venueTypeId: string; // BINARY(16) (Foreign Key)

  @IsNotEmpty()
  floor: string; // VARCHAR(10)

  @IsNotEmpty()
  pricePerHour: number; // DECIMAL(10, 2) CHECK (pricePerHour > 0)
}

export class CreateVenueImageDto {
  @IsNotEmpty()
  locationId: string; // Foreign Key

  @IsNotEmpty()
  venueName: string; // Foreign Key

  @IsUrl()
  @IsNotEmpty()
  locationImgURL: string; // VARCHAR(255)
}
