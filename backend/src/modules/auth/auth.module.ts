import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from '../user/entities/user.entity';
import { JwtModule } from '@nestjs/jwt';
import { AuthGuard, PassportModule } from '@nestjs/passport';
import { EmailModule } from '../email/email.module';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { Email_Verification } from './entities/email_verification.entity';
import { AuthController } from './controller/auth.controller';
import { AuthService } from './service/auth.service';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { JwtStrategy } from './strategies/jwt.strategy';


@Module({
  imports: [
    TypeOrmModule.forFeature([User, Email_Verification]),
    PassportModule,
    JwtModule.registerAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        secret: config.get<string>('JWT_SECRET'),
        signOptions: {expiresIn: '15m'},
      })
    }),
    EmailModule,
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy, JwtAuthGuard]
})
export class AuthModule {}
