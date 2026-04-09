import { Body, Controller, Delete, Get, Param, Post, Req, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CreateCommentDto } from './dto/create_comment.dto';
import { CommentsService } from './comments.service';

@Controller()
export class CommentsController {
  constructor(private readonly commentsService: CommentsService) {}

  @Get('videos/:videoId/comments')
  getComments(@Param('videoId') videoId: string) {
    return this.commentsService.getCommentsByVideoId(videoId);
  }

  @Post('comments')
  @UseGuards(JwtAuthGuard)
  createComment(@Req() req: any, @Body() dto: CreateCommentDto) {
    return this.commentsService.createComment(req.user.user_id, dto.videoId, dto.content, dto.parentId);
  }

  @Delete('comments/:commentId')
  @UseGuards(JwtAuthGuard)
  deleteComment(@Req() req: any, @Param('commentId') commentId: string) {
    return this.commentsService.deleteComment(req.user.user_id, commentId);
  }
}

