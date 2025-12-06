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
  @ApiProperty({ example: 'client-uuid', description: 'Client user ID' })
  @IsNotEmpty()
  @IsString()
  clientId: string;

  @ApiProperty({ example: 'location-uuid', description: 'Location ID to rate' })
  @IsNotEmpty()
  @IsString()
  locationId: string;

  @ApiProperty({
    example: 4,
    description: 'Rating stars (1-5)',
    minimum: 1,
    maximum: 5,
  })
  @IsNotEmpty()
  @IsInt()
  @Min(1)
  @Max(5)
  stars: number;

  @ApiProperty({
    example: 'Great venue with excellent facilities!',
    description: 'Optional review comment',
    required: false,
  })
  @IsOptional()
  @IsString()
  comment?: string;
}

export class UpdateRateDto {
  @ApiProperty({
    example: 5,
    description: 'Updated rating stars (1-5)',
    minimum: 1,
    maximum: 5,
    required: false,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(5)
  stars?: number;

  @ApiProperty({
    example: 'Updated review: Amazing experience!',
    description: 'Updated review comment',
    required: false,
  })
  @IsOptional()
  @IsString()
  comment?: string;
}

export class RateResponseDto {
  @ApiProperty({ example: 'client-uuid', description: 'Client user ID' })
  clientId: string;

  @ApiProperty({ example: 'location-uuid', description: 'Location ID' })
  locationId: string;

  @ApiProperty({ example: 4, description: 'Rating stars (1-5)' })
  stars: number;

  @ApiProperty({
    example: 'Great venue!',
    description: 'Review comment',
    required: false,
  })
  comment?: string;

  @ApiProperty({
    example: '2024-12-05T10:30:00Z',
    description: 'Rating creation timestamp',
  })
  createdAt: string;

  @ApiProperty({
    example: '2024-12-05T15:45:00Z',
    description: 'Rating last update timestamp',
    required: false,
  })
  updatedAt?: string;

  @ApiProperty({
    example: 'John Doe',
    description: 'Client full name',
  })
  clientName: string;

  @ApiProperty({
    example: 'https://example.com/avatar.jpg',
    description: 'Client avatar URL',
    required: false,
  })
  avatarURL?: string;
}

export class LocationRatingsDto {
  @ApiProperty({ example: 'location-uuid', description: 'Location ID' })
  locationId: string;

  @ApiProperty({ example: 4.5, description: 'Average rating' })
  avgRating: number;

  @ApiProperty({ example: 42, description: 'Total number of ratings' })
  totalRatings: number;

  @ApiProperty({ type: [RateResponseDto], description: 'List of all ratings' })
  ratings: RateResponseDto[];
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

  @IsNotEmpty()
  @IsString()
  name: string;
}

export class UpdateAmenityDto {
  @IsOptional()
  @IsString()
  name?: string;

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

export class LocationSearchResultDto {
  @ApiProperty({ example: '30303030-3030-3030-3030-303030303002' })
  location_id: string;

  @ApiProperty({ example: 'Heidi Meeting Suites' })
  location_name: string;

  @ApiProperty({ example: '7' })
  addrNo: string;

  @ApiProperty({ example: 'Ward 2' })
  ward: string;

  @ApiProperty({ example: 'Da Nang' })
  city: string;

  @ApiProperty({ example: '3.5' })
  avgRating: string;

  @ApiProperty({ example: 'https://example.com/thumbs/heidi_suites.jpg' })
  thumbnailURL: string;

  @ApiProperty({ example: 'https://maps.example.com/?q=Heidi+Meeting+Suites' })
  mapURL: string;

  @ApiProperty({ example: '0901234202' })
  location_phone: string;

  @ApiProperty({ example: 'Interview Room' })
  venue_name: string;

  @ApiProperty({ example: '3' })
  floor: string;

  @ApiProperty({ example: '15.0' })
  area: string;

  @ApiProperty({ example: '150000.00' })
  pricePerHour: string;

  @ApiProperty({ example: 'aaaa1111-aaaa-aaaa-aaaa-aaaaaaaa0001' })
  venueType_id: string;

  @ApiProperty({ example: 'Minimalist' })
  theme_name: string;

  @ApiProperty({ example: 1 })
  minCapacity: number;

  @ApiProperty({ example: 40 })
  maxCapacity: number;

  @ApiProperty({ example: 0 })
  is_favor: number;
}

// ===== LOCATION DETAILS RESPONSE DTOs =====

export class LocationBasicInfoDto {
  @ApiProperty({
    example: '30303030-3030-3030-3030-303030303002',
    description: 'Location UUID',
  })
  location_id: string;

  @ApiProperty({
    example: 'Sky Garden Event Space',
    description: 'Location name',
  })
  location_name: string;

  @ApiProperty({
    example: 'Modern event space with panoramic city views',
    description: 'Location description',
    required: false,
  })
  description?: string;

  @ApiProperty({ example: '123', description: 'Address number' })
  addrNo: string;

  @ApiProperty({ example: 'Ben Nghe', description: 'Ward/District' })
  ward: string;

  @ApiProperty({ example: 'Ho Chi Minh City', description: 'City name' })
  city: string;

  @ApiProperty({ example: 4.5, description: 'Average rating' })
  avgRating: number;

  @ApiProperty({
    example: 'No smoking. Pets not allowed.',
    description: 'Location policies',
    required: false,
  })
  policy?: string;

  @ApiProperty({
    example: '+84281234567',
    description: 'Contact phone number',
    required: false,
  })
  phoneNo?: string;

  @ApiProperty({
    example: 'https://maps.google.com/?q=10.7769,106.7009',
    description: 'Google Maps URL',
  })
  mapURL: string;

  @ApiProperty({
    example: 'https://example.com/thumbnail.jpg',
    description: 'Thumbnail image URL',
  })
  thumbnailURL: string;

  @ApiProperty({ example: true, description: 'Is location active' })
  isActive: boolean;

  @ApiProperty({ example: 'owner-uuid', description: 'Owner user ID' })
  owner_id: string;

  @ApiProperty({ example: true, description: 'Is favorited by current user' })
  is_favorited: boolean;
}

export class VenueDetailDto {
  @ApiProperty({ example: 'Conference Room A', description: 'Venue name' })
  venue_name: string;

  @ApiProperty({ example: '3', description: 'Floor number' })
  floor: string;

  @ApiProperty({ example: 50.5, description: 'Area in square meters' })
  area: number;

  @ApiProperty({ example: 150000, description: 'Price per hour in VND' })
  pricePerHour: number;

  @ApiProperty({ example: true, description: 'Is venue active' })
  isActive: boolean;

  @ApiProperty({ example: 'venue-type-uuid', description: 'Venue type ID' })
  venueType_id: string;

  @ApiProperty({ example: 'Minimalist', description: 'Theme name' })
  theme_name: string;

  @ApiProperty({
    example: 'Modern minimalist design',
    description: 'Theme description',
    required: false,
  })
  theme_description?: string;

  @ApiProperty({ example: 10, description: 'Minimum capacity' })
  minCapacity: number;

  @ApiProperty({ example: 50, description: 'Maximum capacity' })
  maxCapacity: number;
}

export class VenueImageDto {
  @ApiProperty({ example: 'Conference Room A', description: 'Venue name' })
  venueName: string;

  @ApiProperty({
    example: 'https://example.com/images/room-a.jpg',
    description: 'Image URL',
  })
  locationImgURL: string;
}

export class AmenityDetailDto {
  @ApiProperty({ example: 'amenity-uuid', description: 'Amenity ID' })
  amenity_id: string;

  @ApiProperty({ example: 'Projector', description: 'Amenity category' })
  category: string;

  @ApiProperty({
    example: '4K HD Projector with screen',
    description: 'Amenity description',
    required: false,
  })
  description?: string;

  @ApiProperty({ example: 50000, description: 'Price in VND' })
  price: number;

  @ApiProperty({ example: true, description: 'Is amenity available' })
  isActive: boolean;
}

export class ReviewDetailDto {
  @ApiProperty({ example: 'client-uuid', description: 'Client user ID' })
  client_id: string;

  @ApiProperty({ example: 5, description: 'Rating stars (1-5)' })
  stars: number;

  @ApiProperty({
    example: 'Great venue!',
    description: 'Review comment',
    required: false,
  })
  comment?: string;

  @ApiProperty({
    example: '2024-12-05T10:30:00Z',
    description: 'Created timestamp',
  })
  created_at: string;

  @ApiProperty({
    example: '2024-12-05T15:45:00Z',
    description: 'Updated timestamp',
    required: false,
  })
  updated_at?: string;

  @ApiProperty({ example: 'John', description: 'Reviewer first name' })
  firstName: string;

  @ApiProperty({ example: 'Doe', description: 'Reviewer last name' })
  lastName: string;

  @ApiProperty({
    example: 'https://example.com/avatar.jpg',
    description: 'Reviewer avatar URL',
    required: false,
  })
  avatarURL?: string;
}

export class RatingStatisticsDto {
  @ApiProperty({ example: 42, description: 'Total number of ratings' })
  total_ratings: number;

  @ApiProperty({ example: 4.5, description: 'Average rating' })
  avg_rating: number;

  @ApiProperty({ example: 20, description: 'Number of 5-star ratings' })
  five_stars: number;

  @ApiProperty({ example: 15, description: 'Number of 4-star ratings' })
  four_stars: number;

  @ApiProperty({ example: 5, description: 'Number of 3-star ratings' })
  three_stars: number;

  @ApiProperty({ example: 2, description: 'Number of 2-star ratings' })
  two_stars: number;

  @ApiProperty({ example: 0, description: 'Number of 1-star ratings' })
  one_star: number;
}

export class LocationDetailsResponseDto {
  @ApiProperty({
    type: LocationBasicInfoDto,
    description: 'Location basic information',
  })
  location: LocationBasicInfoDto;

  @ApiProperty({
    type: [VenueDetailDto],
    description: 'List of venues at this location',
  })
  venues: VenueDetailDto[];

  @ApiProperty({ type: [VenueImageDto], description: 'List of venue images' })
  images: VenueImageDto[];

  @ApiProperty({
    type: [AmenityDetailDto],
    description: 'List of available amenities',
  })
  amenities: AmenityDetailDto[];

  @ApiProperty({ type: [ReviewDetailDto], description: 'List of reviews' })
  reviews: ReviewDetailDto[];

  @ApiProperty({ type: RatingStatisticsDto, description: 'Rating statistics' })
  statistics: RatingStatisticsDto;
}

// ===== GET ALL LOCATIONS RESPONSE DTO =====

export class LocationListItemDto {
  @ApiProperty({
    example: '30303030-3030-3030-3030-303030303002',
    description: 'Location UUID',
  })
  location_id: string;

  @ApiProperty({
    example: 'Sky Garden Event Space',
    description: 'Location name',
  })
  location_name: string;

  @ApiProperty({
    example: 'Modern event space with panoramic city views',
    description: 'Location description',
    required: false,
  })
  description?: string;

  @ApiProperty({ example: '123', description: 'Address number' })
  addrNo: string;

  @ApiProperty({ example: 'Ben Nghe', description: 'Ward/District' })
  ward: string;

  @ApiProperty({ example: 'Ho Chi Minh City', description: 'City name' })
  city: string;

  @ApiProperty({ example: 4.5, description: 'Average rating' })
  avgRating: number;

  @ApiProperty({
    example: 'https://example.com/thumbnail.jpg',
    description: 'Thumbnail image URL',
  })
  thumbnailURL: string;

  @ApiProperty({
    example: 'https://maps.google.com/?q=10.7769,106.7009',
    description: 'Google Maps URL',
  })
  mapURL: string;

  @ApiProperty({
    example: '+84281234567',
    description: 'Contact phone number',
    required: false,
  })
  phoneNo?: string;

  @ApiProperty({ example: 'owner-uuid', description: 'Owner user ID' })
  owner_id: string;

  @ApiProperty({ example: true, description: 'Is location active' })
  isActive: boolean;

  @ApiProperty({
    example: '2024-12-05T10:30:00Z',
    description: 'Created timestamp',
  })
  createdAt: string;

  @ApiProperty({
    example: '2024-12-05T15:45:00Z',
    description: 'Updated timestamp',
  })
  updatedAt: string;

  @ApiProperty({ example: true, description: 'Is favorited by current user' })
  is_favorited: boolean;

  @ApiProperty({
    example: 5,
    description: 'Total number of venues at this location',
  })
  total_venues: number;

  @ApiProperty({
    example: 100000,
    description: 'Minimum price per hour across all venues',
  })
  min_price: number;

  @ApiProperty({
    example: 500000,
    description: 'Maximum price per hour across all venues',
  })
  max_price: number;

  @ApiProperty({ example: 42, description: 'Total number of reviews' })
  total_reviews: number;
}
