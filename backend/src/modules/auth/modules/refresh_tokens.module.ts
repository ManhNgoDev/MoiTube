import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TypeORMError } from 'typeorm';
import { Refresh_Tokens } from '../entities/refresh_tokens.entity';


@Module({
    imports: [TypeOrmModule.forFeature([Refresh_Tokens])],
    exports: [TypeOrmModule]
})
export class RefreshTokensModule {}
