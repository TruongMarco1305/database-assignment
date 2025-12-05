declare global {
  namespace NodeJS {
    interface ProcessEnv {
      DB_NAME: string;
      DB_USER: string;
      DB_PASSWORD: string;
      DB_HOST: string;

      NODE_ENV: string;
      PORT: string;

      JWT_SECRET: string;
      JWT_REFRESH_SECRET: string;

      GOOGLE_CLIENT_ID: string;
      GOOGLE_CLIENT_SECRET: string;

      MINIO_ENDPOINT: string;
      MINIO_PORT: string;
      MINIO_USE_SSL: string;
      MINIO_ACCESS_KEY: string;
      MINIO_SECRET_KEY: string;
    }
  }

  namespace Express {
    interface Request {
      customProps: object;
    }

    interface User {
      userId: string;
      role: string;
    }
  }
}

export {};
