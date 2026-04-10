import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { WatchHistory } from '../entities/watch_history.entity';
import { Video } from '../../videos/entities/video.entity';

@Injectable()
export class HistoryService {
    constructor(
        @InjectRepository(WatchHistory)
        private historyRepo: Repository<WatchHistory>,
        @InjectRepository(Video)
        private videoRepo: Repository<Video>,
    ) {}

    async addOrUpdateHistory(userId: string, videoId: string) {
        const video = await this.videoRepo.findOne({ where: { id: videoId } });
        if (!video) throw new NotFoundException('Video không tồn tại');

        const existing = await this.historyRepo.findOne({
            where: { user_id: userId, video_id: videoId }
        });

        if (existing) {
            existing.watched_at = new Date();
            return await this.historyRepo.save(existing);
        } else {
            const newHistory = this.historyRepo.create({
                user_id: userId,
                video_id: videoId,
                watched_at: new Date()
            });
            return await this.historyRepo.save(newHistory);
        }
    }

    async getHistory(userId: string, page = 1, limit = 20) {
        const skip = (page - 1) * limit;

        const [items, total] = await this.historyRepo.findAndCount({
            where: { user_id: userId },
            relations: ['video', 'video.channel', 'video.channel.user'],
            order: { watched_at: 'DESC' },
            skip,
            take: limit
        });

        return {
            data: items.map(h => ({
                id: h.id,
                watchedAt: h.watched_at,
                video: h.video
            })),
            total,
            page,
            totalPages: Math.ceil(total / limit)
        };
    }

    async removeHistoryItem(userId: string, videoId: string) {
        const item = await this.historyRepo.findOne({
            where: { user_id: userId, video_id: videoId }
        });

        if (!item) return { success: false, message: 'Không tìm thấy trong lịch sử' };

        await this.historyRepo.remove(item);
        return { success: true, message: 'Đã xóa khỏi lịch sử xem' };
    }

    async clearAllHistory(userId: string) {
        await this.historyRepo.delete({ user_id: userId });
        return { success: true, message: 'Đã xóa toàn bộ lịch sử xem' };
    }
}
