import { Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { Subscription } from "../entities/subsciption.entity";
import { Repository } from "typeorm";
import { ChannelService } from "./channel.service";
import { NotificationService } from "../../notification/service/notification.service";
import { NotificationType } from "../../notification/entities/notification.entity";

@Injectable()
export class SubscriptionService {
    constructor(
        @InjectRepository(Subscription)
        private readonly subRepo: Repository<Subscription>,
        private readonly channelService: ChannelService,
        private readonly notificationService: NotificationService,
    ) {}
    //Đăng ký/ hủy đăng ký
    async subscribeToggle(userId: string, channelId: string): Promise<{subscribed: boolean}> {
        await this.channelService.findChannelById(channelId);

        const existing = await this.subRepo.findOne({
            where: {subscriber_id: userId, channel_id: channelId}
        });

        if(existing) {
            await this.subRepo.remove(existing)
            await this.channelService.incrementSubscriber(channelId, -1)
            return {subscribed: false}
        } else {
            const sub = this.subRepo.create({
                    subscriber_id: userId,
                    channel_id: channelId
            });
            const savedSub = await this.subRepo.save(sub)
            await this.channelService.incrementSubscriber(channelId, 1)

            // Create notification for channel owner
            try {
                const channel = await this.channelService.findChannelById(channelId);
                if (channel?.user?.id) {
                    await this.notificationService.createNotification(
                        channel.user.id,
                        userId,
                        NotificationType.SUBSCRIBE,
                        channelId,
                        `đã đăng ký kênh của bạn`
                    );
                }
            } catch (e) {
                console.error('Error creating subscription notification', e);
            }

            return {subscribed: true}
        }
    }
    //Check user có đang sub hay không
    async isSubscribed(userId: string, channelId: string): Promise<boolean> {
        const existing = await this.subRepo.findOne(
            {where: {subscriber_id: userId, channel_id: channelId}}
        )
        return !!existing
    }
    //Lấy danh sách người đăng ký của một kênh
    async getSubscribers(channelId: string): Promise<Subscription[]> {
        return this.subRepo.find({
            where: { channel_id: channelId },
            relations: ['subscriber'],
            order: { subscribed_at: 'DESC' },
        });
    }

    //Lấy danh sách kênh mà một user đang đăng ký
    async getSubscribedChannels(userId: string): Promise<Subscription[]> {
        return this.subRepo.find({
            where: { subscriber_id: userId },
            relations: ['channel', 'channel.user'],
            order: { subscribed_at: 'DESC' },
        });
    }

    //Bật/tắt thông báo cho một kênh đã đăng ký
    async toggleNotify(userId: string, channelId: string): Promise<{ notify_enabled: boolean }> {
        const sub = await this.subRepo.findOne({
            where: { subscriber_id: userId, channel_id: channelId },
        });

        if (!sub) {
            throw new Error('Bạn chưa đăng ký kênh này');
        }

        sub.notify_enabled = !sub.notify_enabled;
        await this.subRepo.save(sub);

        return { notify_enabled: sub.notify_enabled };
    }
}