import { IsNotEmpty, IsOptional, IsString, IsUUID, MaxLength } from 'class-validator';

export class CreateCommentDto {
  @IsUUID()
  videoId!: string;

  @IsOptional()
  @IsUUID()
  parentId?: string;

  @IsString()
  @IsNotEmpty()
  @MaxLength(2000)
  content!: string;
}

