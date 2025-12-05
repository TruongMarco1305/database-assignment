import { ConfigType, registerAs } from '@nestjs/config';
import { z } from 'zod';

export const commonConfig = registerAs('common', () => {
  const values = {
    port: parseInt(process.env.PORT || '5000', 10),
    dbPort: parseInt(process.env.DB_PORT || '5432', 10),
    dbName: process.env.DB_NAME,
    dbUser: process.env.DB_USER,
    dbPassword: process.env.DB_PASSWORD,
    dbHost: process.env.DB_HOST,
    jwtSecret: process.env.JWT_SECRET,
    minioEndPoint: process.env.MINIO_ENDPOINT ?? '',
    minioAccessKey: process.env.MINIO_ACCESS_KEY ?? '',
    minioSecretKey: process.env.MINIO_SECRET_KEY ?? '',
    minioPort: parseInt(process.env.MINIO_PORT ?? '', 10),
    minioUseSSL: process.env.MINIO_USE_SSL
      ? process.env.MINIO_USE_SSL.toLowerCase() === 'true'
      : true,
  };

  const validationSchema = z.object({
    port: z.number().int().positive(),
    dbPort: z.number().int().positive(),
    dbName: z.string().min(1),
    dbUser: z.string().min(1),
    dbPassword: z.string().min(1),
    dbHost: z.string().min(1),
    jwtSecret: z.string().min(1),
    minioEndPoint: z.string().min(1),
    minioAccessKey: z.string().min(1),
    minioSecretKey: z.string().min(1),
    minioPort: z.number().min(1),
  });

  validationSchema.parse(values);

  return values;
});

export type CommonConfigType = ConfigType<typeof commonConfig>;
