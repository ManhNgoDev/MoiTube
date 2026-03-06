import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from '../user/user.entity';
import { JwtModule } from '@nestjs/jwt';
import { EmailVerificationModule } from '../email_verification/email_verification.module';
import { Email_Verification } from '../email_verification/email_verification.entity';
import { PassportModule } from '@nestjs/passport';
import { EmailModule } from '../email/email.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([User, Email_Verification]),
    PassportModule,
    JwtModule.register({
      secret: process.env.JWT_SECRET ,
      signOptions: { expiresIn: '15m' },
    }),
    EmailModule,
  ],
  controllers: [AuthController],
  providers: [AuthService]
})
export class AuthModule {}
