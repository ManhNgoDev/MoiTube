import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Email_Verification } from './email_verification.entity';

@Module({
    imports: [TypeOrmModule.forFeature([Email_Verification])],
    exports: [TypeOrmModule]
})
export class EmailVerificationModule {}
