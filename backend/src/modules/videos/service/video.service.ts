import { BadRequestException, ForbiddenException, Injectable, NotFoundException } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { Video, VideoStatus } from "../entities/video.entity";
import { DataSource, Repository } from "typeorm";
import { CloudinaryService } from "../../cloudinary/service/cloudinary.service";
import { ChannelService } from "../../channel/service/channel.service";
import { CreateVideoDto } from "../dto/create_video.dto";
import { SubscriptionService } from "../../channel/service/subscription.service";
import { VideoLike, VideoLikeType } from "../entities/video_like.entity";
import { NotificationService } from "../../notification/service/notification.service";
import { NotificationType } from "../../notification/entities/notification.entity";

@Injectable()
export class VideoService {
    constructor(
        @InjectRepository(Video)
        private readonly videoRepo: Repository<Video>,
        @InjectRepository(VideoLike)
        private readonly videoLikeRepo: Repository<VideoLike>,
        private readonly cloudinaryService: CloudinaryService,
        private readonly channelService: ChannelService,
        private readonly subscriptionService: SubscriptionService,
        private readonly dataSource: DataSource,
        private readonly notificationService: NotificationService,
    ) { }

    async createVideo(
        userId: string,
        dto: CreateVideoDto,
        videoFile?: Express.Multer.File,
        thumbnailFile?: Express.Multer.File
    ): Promise<Video> {
        const channel = await this.channelService.findById(userId);

        const videoResult = await this.cloudinaryService.uploadVideo(videoFile!)

        const duration = videoResult['duration']

        if (duration > 15 * 60) {
            await this.cloudinaryService.deleteFile(videoResult.public_id, 'video')
            throw new BadRequestException('Video không được vượt quá 15 phút')
        }

        let thumbnailUrl: string | undefined = undefined;
        if (thumbnailFile) {
            const thumbResult = await this.cloudinaryService.uploadImage(
                thumbnailFile,
                'moitube/thumbnails',
            );
            thumbnailUrl = thumbResult.secure_url;
        }

        const videoEntity = this.videoRepo.create({
            channel,
            title: dto.title,
            description: dto.description,
            video_url: videoResult.secure_url,
            thumbnail_url: thumbnailUrl,
            duration: Math.round(duration),
            status: dto.status || VideoStatus.PUBLIC,
            published_at: new Date(),
        });

        const savedVideo = await this.videoRepo.save(videoEntity);

        // Tăng video_count của channel
        await this.channelService.incrementVideoCount(channel.id, 1);

        // Create notifications for subscribers
        try {
            const subscribers = await this.subscriptionService.getSubscribers(channel.id);
            for (const sub of subscribers) {
                await this.notificationService.createNotification(
                    sub.subscriber_id,
                    userId,
                    NotificationType.NEW_VIDEO,
                    savedVideo.id,
                    `vừa đăng video mới: ${savedVideo.title}`
                );
            }
        } catch (e) {
            console.error('Error creating video publish notifications', e);
        }

        return savedVideo;
    }

    async getVideos(userId: string, page = 1, limit = 10) {
        const skip = (page - 1) * limit;

        let subscribedChannelIds: string[] = [];
        if (userId) {
            const subscriptions = await this.subscriptionService.getSubscribedChannels(userId);
            subscribedChannelIds = subscriptions.map(sub => sub.channel_id);
        }

        const qb = this.videoRepo
            .createQueryBuilder('video')
            .leftJoinAndSelect('video.channel', 'channel')
            .leftJoinAndSelect('channel.user', 'user')
            .where('video.status = :status', { status: VideoStatus.PUBLIC })

        if (subscribedChannelIds.length > 0) {
            qb.orderBy(
                'CASE WHEN channel.id IN (:...ids) THEN 0 ELSE 1 END',
                'ASC'
            )
                .addOrderBy('video.published_at', 'DESC')
                .setParameter('ids', subscribedChannelIds)
        } else {
            qb.orderBy('video.published_at', 'DESC')
        }

        const [data, total] = await qb
            .skip(skip)
            .take(limit)
            .getManyAndCount();

        return {
            data,
            total,
            page,
            totalPages: Math.ceil(total / limit)
        };
    }

    async getSubscriptionFeed(userId: string, page = 1, limit = 10) {
        const skip = (page - 1) * limit;
        const subscriptions = await this.subscriptionService.getSubscribedChannels(userId);
        const subscribedChannelIds = subscriptions.map((sub) => sub.channel_id);

        if (subscribedChannelIds.length === 0) {
            return { data: [], total: 0, page, totalPages: 0 };
        }

        const qb = this.videoRepo
            .createQueryBuilder('video')
            .leftJoinAndSelect('video.channel', 'channel')
            .leftJoinAndSelect('channel.user', 'user')
            .where('video.status = :status', { status: VideoStatus.PUBLIC })
            .andWhere('channel.id IN (:...ids)', { ids: subscribedChannelIds })
            .orderBy('video.published_at', 'DESC')
            .skip(skip)
            .take(limit);

        const [data, total] = await qb.getManyAndCount();

        return {
            data,
            total,
            page,
            totalPages: Math.ceil(total / limit),
        };
    }

    async getVideoById(id: string): Promise<Video> {
        const video = await this.videoRepo.findOne({
            where: { id },
            relations: ['channel', 'channel.user']
        });

        if (!video) throw new NotFoundException('Video không tồn tại');

        return video;
    }

    async updateVideo(id: string, userId: string, updateData: Partial<Video>): Promise<Video> {
        const video = await this.getVideoById(id);

        if (video.channel.user.id !== userId) {
            throw new ForbiddenException('Bạn không có quyền chỉnh sửa video này');
        }

        Object.assign(video, updateData);
        return await this.videoRepo.save(video);
    }

    async deleteVideo(id: string, userId: string): Promise<void> {
        const video = await this.getVideoById(id);

        if (video.channel.user.id !== userId) {
            throw new ForbiddenException('Bạn không có quyền xóa video này');
        }

        await this.videoRepo.remove(video);

        // Cập nhật lại số lượng video của channel
        await this.channelService.incrementVideoCount(video.channel.id, -1);
    }

    async incrementView(id: string): Promise<void> {
        await this.videoRepo.increment({ id }, 'view_count', 1);
        const video = await this.getVideoById(id);
        await this.channelService.incrementViewCount(video.channel.id, 1);
    }

    async incrementLikeCount(id: string, delta: number): Promise<void> {
        await this.videoRepo.increment({ id }, 'like_count', delta);
    }

    async incrementDislikeCount(id: string, delta: number): Promise<void> {
        await this.videoRepo.increment({ id }, 'dislike_count', delta);
    }

    async toggleVideoReaction(userId: string, videoId: string, type: VideoLikeType) {
        if (type !== VideoLikeType.LIKE && type !== VideoLikeType.DISLIKE) {
            throw new BadRequestException('type không hợp lệ');
        }

        return this.dataSource.transaction(async (manager) => {
            const videoRepo = manager.getRepository(Video);
            const likeRepo = manager.getRepository(VideoLike);

            const video = await videoRepo.findOne({ where: { id: videoId }, relations: ['channel', 'channel.user'] });
            if (!video) throw new NotFoundException('Video không tồn tại');

            // Không cho chủ video tự like/dislike video của mình
            if (video.channel?.user?.id && video.channel.user.id === userId) {
                throw new ForbiddenException('Không thể like/dislike video của chính bạn');
            }

            const existing = await likeRepo.findOne({
                where: { user_id: userId, video_id: videoId },
            });

            const inc = async (field: 'like_count' | 'dislike_count', delta: number) => {
                await videoRepo.increment({ id: videoId }, field, delta);
            };

            if (!existing) {
                const created = likeRepo.create({
                    user_id: userId,
                    video_id: videoId,
                    type,
                });
                await likeRepo.save(created);
                await inc(type === VideoLikeType.LIKE ? 'like_count' : 'dislike_count', 1);

                // Create notification for LIKE
                if (type === VideoLikeType.LIKE && video.channel?.user?.id) {
                    await this.notificationService.createNotification(
                        video.channel.user.id,
                        userId,
                        NotificationType.LIKE,
                        videoId,
                        `đã thích video của bạn: ${video.title}`
                    );
                }

                return { type, active: true };
            }

            if (existing.type === type) {
                await likeRepo.remove(existing);
                await inc(type === VideoLikeType.LIKE ? 'like_count' : 'dislike_count', -1);
                return { type, active: false };
            }

            // Switch like <-> dislike
            const prevType = existing.type;
            existing.type = type;
            await likeRepo.save(existing);
            await inc(prevType === VideoLikeType.LIKE ? 'like_count' : 'dislike_count', -1);
            await inc(type === VideoLikeType.LIKE ? 'like_count' : 'dislike_count', 1);
            return { type, active: true };
        });
    }

    async getMyVideoReaction(userId: string, videoId: string) {
        const video = await this.videoRepo.findOne({ where: { id: videoId }, relations: ['channel', 'channel.user'] });
        if (!video) throw new NotFoundException('Video không tồn tại');

        // Owner => treat as no reaction (and cannot react)
        if (video.channel?.user?.id && video.channel.user.id === userId) {
            return { type: null, active: false, owner: true };
        }

        const existing = await this.videoLikeRepo.findOne({ where: { user_id: userId, video_id: videoId } });
        return { type: existing?.type ?? null, active: !!existing, owner: false };
    }

    async searchVideoByTitleBinary(title: string): Promise<Video | null> {
        const videos = await this.videoRepo.find({
            where: { status: VideoStatus.PUBLIC },
            relations: ['channel', 'channel.user']
        });

        videos.sort((a, b) => a.title.localeCompare(b.title));

        let left = 0;
        let right = videos.length - 1;
        const targetTitle = title.toLowerCase();

        while (left <= right) {
            const mid = Math.floor((left + right) / 2);
            const midTitle = videos[mid].title.toLowerCase();

            if (midTitle === targetTitle) {
                return videos[mid];
            }

            if (midTitle < targetTitle) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }

        return null;
    }

    async searchVideos(query: string, page = 1, limit = 10) {
        const q = query.trim();
        if (!q) {
            return { data: [], total: 0, page, totalPages: 0 };
        }

        const skip = (page - 1) * limit;

        const qb = this.videoRepo
            .createQueryBuilder('video')
            .leftJoinAndSelect('video.channel', 'channel')
            .leftJoinAndSelect('channel.user', 'user')
            .where('video.status = :status', { status: VideoStatus.PUBLIC })
            .andWhere('(video.title ILIKE :q OR video.description ILIKE :q)', { q: `%${q}%` })
            .orderBy('video.published_at', 'DESC')
            .skip(skip)
            .take(limit);

        const [data, total] = await qb.getManyAndCount();

        return {
            data,
            total,
            page,
            totalPages: Math.ceil(total / limit),
        };
    }

    async getVideosByChannelHandle(handle: string, page = 1, limit = 12) {
        const h = handle.trim();
        if (!h) {
            return { data: [], total: 0, page, totalPages: 0 };
        }

        const skip = (page - 1) * limit;
        const qb = this.videoRepo
            .createQueryBuilder('video')
            .leftJoinAndSelect('video.channel', 'channel')
            .leftJoinAndSelect('channel.user', 'user')
            .where('video.status = :status', { status: VideoStatus.PUBLIC })
            .andWhere('channel.handle = :handle', { handle: h })
            .orderBy('video.published_at', 'DESC')
            .skip(skip)
            .take(limit);

        const [data, total] = await qb.getManyAndCount();

        return {
            data,
            total,
            page,
            totalPages: Math.ceil(total / limit),
        };
    }
}