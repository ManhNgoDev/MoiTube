import { IsEnum, IsNotEmpty, IsOptional, IsString, MaxLength } from "class-validator";
import { VideoStatus } from "../entities/video.entity";

export class CreateVideoDto {
    @IsNotEmpty()
    @IsString()
    @MaxLength(100)
    title!: string;

    @IsOptional()
    @IsString()
    @MaxLength(1000)
    description?: string;

    @IsOptional()
    @IsEnum(VideoStatus)
    status?: VideoStatus;
}