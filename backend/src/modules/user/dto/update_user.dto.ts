import { IsOptional, IsString, IsUrl } from 'class-validator';

export class UpdateUserDto {
    @IsOptional()
    @IsString()
    @IsUrl()
    avatar_url?: string;
}
