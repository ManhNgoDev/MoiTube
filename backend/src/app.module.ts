import { Module } from '@nestjs/common';
import { AuthModule } from './modules/auth/auth.module';
import { UserModule } from './modules/user/user.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { RefreshTokensModule } from './modules/auth/modules/refresh_tokens.module';
import { EmailVerificationModule } from './modules/auth/modules/email_verification.module';
import { EmailModule } from './modules/email/email.module';
import { ChannelModule } from './modules/channel/channel.module';
import { VideoModule } from './modules/videos/video.module';
import { CommentsModule } from './modules/comments/comments.module';
import { NotificationModule } from './modules/notification/notification.module';
import { HistoryModule } from './modules/history/history.module';

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
        synchronize: config.get<string>('NODE_ENV') !== 'production',
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
    ChannelModule,
    VideoModule,
    CommentsModule,
    NotificationModule,
    HistoryModule,
  ]
})
export class AppModule {}
