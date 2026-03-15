import { Body, Controller, Post, Req, UploadedFiles, UseGuards, UseInterceptors } from "@nestjs/common";
import { FileFieldsInterceptor } from "@nestjs/platform-express";
import { VideoService } from "../service/video.service";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { CreateVideoDto } from "../dto/create_video.dto";

@Controller('videos')
export class VideoController {
  constructor(private readonly videoService: VideoService) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  @UseInterceptors(FileFieldsInterceptor([
    { name: 'video', maxCount: 1 },
    { name: 'thumbnail', maxCount: 1 },
  ]))
  createVideo(
    @Body() body: CreateVideoDto,
    @Req() req,
    @UploadedFiles() files: { 
      video?: Express.Multer.File[], 
      thumbnail?: Express.Multer.File[] 
    },
  ) {
    return this.videoService.createVideo(
      req.user.sub,  // ← sub không phải id
      body,
      files.video?.[0],
      files.thumbnail?.[0],
    );
  }
}