import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { Comment } from './entities/comment.entity';
import { Video } from '../videos/entities/video.entity';
import { User } from '../user/entities/user.entity';
import { NotificationService } from '../notification/service/notification.service';
import { NotificationType } from '../notification/entities/notification.entity';

@Injectable()
export class CommentsService {
  constructor(
    @InjectRepository(Comment) private readonly commentRepo: Repository<Comment>,
    @InjectRepository(Video) private readonly videoRepo: Repository<Video>,
    @InjectRepository(User) private readonly userRepo: Repository<User>,
    private readonly dataSource: DataSource,
    private readonly notificationService: NotificationService,
  ) {}

  async getCommentsByVideoId(videoId: string) {
    const video = await this.videoRepo.findOne({ where: { id: videoId } });
    if (!video) throw new NotFoundException('Video không tồn tại');

    const comments = await this.commentRepo.find({
      where: { video: { id: videoId } },
      relations: ['user', 'parent'],
      order: { created_at: 'DESC' },
      take: 100,
    });

    return comments.map((c) => ({
      id: c.id,
      userId: c.user.id,
      username: c.user.username,
      avatarUrl: c.user.avatar_url || null,
      parentId: c.parent?.id ?? null,
      content: c.content,
      likeCount: c.like_count ?? 0,
      createdAt: c.created_at,
    }));
  }

  async createComment(userId: string, videoId: string, content: string, parentId?: string) {
    return this.dataSource.transaction(async (manager) => {
      const video = await manager.getRepository(Video).findOne({ where: { id: videoId } });
      if (!video) throw new NotFoundException('Video không tồn tại');

      const user = await manager.getRepository(User).findOne({ where: { id: userId } });
      if (!user) throw new NotFoundException('User không tồn tại');

      let parent: Comment | null = null;
      if (parentId) {
        const found = await manager.getRepository(Comment).findOne({
          where: { id: parentId },
          relations: ['video'],
        });
        if (!found) throw new NotFoundException('Comment cha không tồn tại');
        if (found.video.id !== videoId) throw new ForbiddenException('Không thể reply khác video');
        parent = found;
      }

      const entity = manager.getRepository(Comment).create({
        video,
        user,
        parent,
        content,
      });

      const saved = await manager.getRepository(Comment).save(entity);
      await manager.getRepository(Video).increment({ id: videoId }, 'comment_count', 1);

      // Create notification for video owner
      try {
        const videoWithChannel = await manager.getRepository(Video).findOne({
          where: { id: videoId },
          relations: ['channel', 'channel.user'],
        });
        if (videoWithChannel?.channel?.user?.id) {
          await this.notificationService.createNotification(
            videoWithChannel.channel.user.id,
            userId,
            NotificationType.COMMENT,
            videoId,
            `đã bình luận về video của bạn: ${content.substring(0, 30)}${content.length > 30 ? '...' : ''}`
          );
        }
      } catch (e) {
        console.error('Error creating comment notification', e);
      }

      return {
        id: saved.id,
        userId: user.id,
        username: user.username,
        avatarUrl: user.avatar_url || null,
        parentId: parent?.id ?? null,
        content: saved.content,
        likeCount: saved.like_count ?? 0,
        createdAt: saved.created_at,
      };
    });
  }

  async deleteComment(userId: string, commentId: string) {
    return this.dataSource.transaction(async (manager) => {
      const repo = manager.getRepository(Comment);
      const comment = await repo.findOne({
        where: { id: commentId },
        relations: ['user', 'video'],
      });
      if (!comment) throw new NotFoundException('Comment không tồn tại');

      if (comment.user.id !== userId) {
        throw new ForbiddenException('Bạn không có quyền xóa bình luận này');
      }

      const videoId = comment.video.id;
      await repo.remove(comment);
      await manager.getRepository(Video).increment({ id: videoId }, 'comment_count', -1);
      return { success: true };
    });
  }
}

