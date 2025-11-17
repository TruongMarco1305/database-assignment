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
    jwtRefreshSecret: process.env.JWT_REFRESH_SECRET,
    googleClientId: process.env.GOOGLE_CLIENT_ID,
    googleClientSecret: process.env.GOOGLE_CLIENT_SECRET,
  };

  const validationSchema = z.object({
    nodeEnv: z.enum(['development', 'production', 'local']),
    port: z.number().int().positive(),
    dbPort: z.number().int().positive(),
    dbName: z.string().min(1),
    dbUser: z.string().min(1),
    dbPassword: z.string().min(1),
    dbHost: z.string().min(1),
    jwtSecret: z.string().min(1),
    jwtRefreshSecret: z.string().min(1),
    googleClientId: z.string().min(1),
    googleClientSecret: z.string().min(1),
  });

  validationSchema.parse(values);

  return values;
});

export type CommonConfigType = ConfigType<typeof commonConfig>;
