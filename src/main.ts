import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import * as yaml from 'js-yaml';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const frontendOrigin = 'http://localhost:3000';
  app.enableCors({
    origin: frontendOrigin, // The specific domain/port of your frontend
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
    credentials: true, // <--- THIS IS THE KEY FIX
  });

  // Swagger Configuration
  const config = new DocumentBuilder()
    .setTitle('Venue Booking System API')
    .setDescription(
      'API documentation for the Venue Booking System - manage locations, venues, bookings, and payments',
    )
    .setVersion('1.0')
    .addBearerAuth(
      {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        name: 'JWT',
        description: 'Enter JWT token',
        in: 'header',
      },
      'JWT-auth',
    )
    .build();

  const document = SwaggerModule.createDocument(app, config);

  // Setup Swagger UI at /api
  SwaggerModule.setup('api', app, document, {
    swaggerOptions: {
      persistAuthorization: true,
    },
    customSiteTitle: 'Venue Booking API Docs',
  });

  // Serve YAML file at /swagger/yaml
  app.use('/swagger/yaml', (req, res) => {
    res.setHeader('Content-Type', 'text/yaml');
    res.send(yaml.dump(document));
  });

  // Serve JSON file at /swagger/json
  app.use('/swagger/json', (req, res) => {
    res.setHeader('Content-Type', 'application/json');
    res.send(JSON.stringify(document, null, 2));
  });

  await app.listen(process.env.PORT ?? 3001);
  console.log(
    `\n🚀 Application is running on: http://localhost:${process.env.PORT ?? 3001}`,
  );
  console.log(
    `📚 Swagger UI: http://localhost:${process.env.PORT ?? 3001}/api`,
  );
  console.log(
    `📄 Swagger YAML: http://localhost:${process.env.PORT ?? 3001}/swagger/yaml`,
  );
  console.log(
    `📄 Swagger JSON: http://localhost:${process.env.PORT ?? 3001}/swagger/json\n`,
  );
}
bootstrap();
