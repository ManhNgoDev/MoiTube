import { Body, Controller, Delete, Get, Param, Patch, Post, Query, Req, UploadedFiles, UseGuards, UseInterceptors } from "@nestjs/common";
import { FileFieldsInterceptor } from "@nestjs/platform-express";
import { VideoService } from "../service/video.service";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { CreateVideoDto } from "../dto/create_video.dto";
import { UpdateVideoDto } from "../dto/update_video.dto";
import { VideoLikeType } from "../entities/video_like.entity";

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
    @Req() req: any,
    @UploadedFiles() files: { 
      video?: Express.Multer.File[], 
      thumbnail?: Express.Multer.File[] 
    },
  ) {
    return this.videoService.createVideo(
      req.user.user_id,
      body,
      files.video?.[0],
      files.thumbnail?.[0],
    );
  }

  @Get()
  getVideos(
    @Query('page') page: string,
    @Query('limit') limit: string,
    @Req() req: any
  ) {
    // Nếu có token gửi kèm (đã parse qua middleware) thì sẽ có req.user.user_id để lấy danh sách quan tâm
    const userId = req.user?.user_id;
    return this.videoService.getVideos(userId, +page || 1, +limit || 10);
  }

  @Get('search/binary')
  searchVideoByTitleBinary(@Query('title') title: string) {
    if (!title) return null;
    return this.videoService.searchVideoByTitleBinary(title);
  }

  @Get('search')
  searchVideos(
    @Query('query') query: string,
    @Query('page') page: string,
    @Query('limit') limit: string,
  ) {
    return this.videoService.searchVideos(query || '', +page || 1, +limit || 10);
  }

  @Get('channel/:handle')
  getVideosByChannelHandle(
    @Param('handle') handle: string,
    @Query('page') page: string,
    @Query('limit') limit: string,
  ) {
    return this.videoService.getVideosByChannelHandle(handle, +page || 1, +limit || 12);
  }

  @Get('subscriptions/feed')
  @UseGuards(JwtAuthGuard)
  getSubscriptionFeed(
    @Req() req: any,
    @Query('page') page: string,
    @Query('limit') limit: string,
  ) {
    return this.videoService.getSubscriptionFeed(req.user.user_id, +page || 1, +limit || 10);
  }

  @Get(':id')
  getVideoById(@Param('id') id: string) {
    return this.videoService.getVideoById(id);
  }

  @Get(':id/my-reaction')
  @UseGuards(JwtAuthGuard)
  getMyReaction(@Param('id') id: string, @Req() req: any) {
    return this.videoService.getMyVideoReaction(req.user.user_id, id);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  updateVideo(
    @Param('id') id: string,
    @Req() req: any,
    @Body() updateData: UpdateVideoDto,
  ) {
    return this.videoService.updateVideo(id, req.user.user_id, updateData);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  deleteVideo(
    @Param('id') id: string,
    @Req() req: any,
  ) {
    return this.videoService.deleteVideo(id, req.user.user_id);
  }

  @Post(':id/view')
  incrementView(@Param('id') id: string) {
    return this.videoService.incrementView(id);
  }

  @Post(':id/like')
  @UseGuards(JwtAuthGuard)
  like(@Param('id') id: string, @Req() req: any, @Body('delta') delta?: number) {
    if (typeof delta === 'number') {
      return this.videoService.incrementLikeCount(id, delta || 1);
    }
    return this.videoService.toggleVideoReaction(req.user.user_id, id, VideoLikeType.LIKE);
  }

  @Post(':id/dislike')
  @UseGuards(JwtAuthGuard)
  dislike(@Param('id') id: string, @Req() req: any, @Body('delta') delta?: number) {
    if (typeof delta === 'number') {
      return this.videoService.incrementDislikeCount(id, delta || 1);
    }
    return this.videoService.toggleVideoReaction(req.user.user_id, id, VideoLikeType.DISLIKE);
  }

  @Post(':id/react')
  @UseGuards(JwtAuthGuard)
  react(@Param('id') id: string, @Req() req: any, @Body('type') type: VideoLikeType) {
    return this.videoService.toggleVideoReaction(req.user.user_id, id, type);
  }
}