import { Body, Controller, Injectable, Post, UseGuards } from '@nestjs/common';
import { MinioStorageService } from './services/minio-storage.service';
import { AuthGuard } from 'src/auth/guards';
import { User } from 'src/auth/decorators';

@Injectable()
@Controller('storage')
export class MinioStorageController {
  constructor(private readonly minioStorageService: MinioStorageService) {}

  @Post('')
  @UseGuards(AuthGuard)
  public async getPresignedUrl(
    @Body() body: { key: string },
    @User() user: Express.User,
  ) {
    const url = await this.minioStorageService.getPresignedUploadUrl(
      'booking-classroom-assets',
      `booking-database/${user.userId}/${body.key}`,
    );
    return url;
  }
}
