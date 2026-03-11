import { IsObject, IsOptional, IsString, IsUrl, Matches, MaxLength } from "class-validator";

export class UpdateChannelDto {
    @IsOptional()
    @IsString()
    @MaxLength(50)
    @Matches(/^[a-z0-9_]+$/, {
      message: 'handle chỉ được chứa chữ thường, số và dấu gạch dưới',
    })
    handle?: string;

    @IsOptional()
    @IsString()
    @MaxLength(100)
    name?: string;

    @IsOptional()
    @IsString()
    @MaxLength(1000)
    description?: string;

    @IsOptional()
    @IsString()
    banner_url?: string;

    @IsOptional()
    @IsUrl()
    website_url?: string;

    @IsOptional()
    @IsObject()
    social_links?: Record<string, string>;
}