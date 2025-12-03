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
