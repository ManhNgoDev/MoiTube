import { Module } from '@nestjs/common';
import { AuthModule } from './modules/auth/auth.module';
import { UserModule } from './modules/user/user.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { RefreshTokensModule } from './modules/refresh_tokens/refresh_tokens.module';
import { EmailVerificationModule } from './modules/email_verification/email_verification.module';
import { EmailModule } from './modules/email/email.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        type: 'postgres',
        url: config.get<string>('DATABASE_URL'),
        autoLoadEntities: true,
        synchronize: true,
        logging: ['error'],
        ssl: {
          rejectUnauthorized: false
        },
      }),
    }),
    AuthModule,
    UserModule,
    RefreshTokensModule,
    EmailVerificationModule,
    EmailModule,
  ]
})
export class AppModule {}
