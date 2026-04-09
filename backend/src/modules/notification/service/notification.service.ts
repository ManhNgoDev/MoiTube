import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Notification, NotificationType } from '../entities/notification.entity';

@Injectable()
export class NotificationService {
  constructor(
    @InjectRepository(Notification)
    private notificationRepository: Repository<Notification>,
  ) {}

  async getNotifications(userId: string, page = 1, limit = 20) {
    const [data, total] = await this.notificationRepository.findAndCount({
      where: { user_id: userId },
      relations: ['actor', 'actor.user'], // Join with actor and their user profile for avatar
      order: { created_at: 'DESC' },
      skip: (page - 1) * limit,
      take: limit,
    });

    return {
      data,
      total,
      page,
      lastPage: Math.ceil(total / limit),
    };
  }

  async createNotification(
    userId: string,
    actorId: string,
    type: NotificationType,
    resourceId?: string,
    message?: string,
  ) {
    // Don't notify if actor is the same as the user receiving it
    if (userId === actorId) return;

    const notification = this.notificationRepository.create({
      user_id: userId,
      actor_id: actorId,
      type,
      resource_id: resourceId,
      message,
    });

    return this.notificationRepository.save(notification);
  }

  async markAsRead(id: string, userId: string) {
    await this.notificationRepository.update(
      { id, user_id: userId },
      { is_read: true },
    );
  }

  async markAllAsRead(userId: string) {
    await this.notificationRepository.update(
      { user_id: userId, is_read: false },
      { is_read: true },
    );
  }
}
