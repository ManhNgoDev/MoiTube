import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DataSource } from 'typeorm';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);


  app.enableCors({
    origin: '*',
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    allowedHeaders: 'Content-Type, Authorization',
  });

  const dataSource = app.get(DataSource);

  app.useGlobalPipes(new ValidationPipe({
    whitelist: true,
    forbidNonWhitelisted: true,
    transform: true
  }));

  if (dataSource.isInitialized) {
    console.log('Connected to PostgreSQL successfully!');
  }

  const port = process.env.PORT || 3000;
  await app.listen(port);
  console.log(`Server running on port ${port} | ENV: ${process.env.NODE_ENV || 'development'}`);
}
bootstrap();
