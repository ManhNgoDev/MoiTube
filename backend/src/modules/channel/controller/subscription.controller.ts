import {
    Controller,
    Delete,
    Get,
    Param,
    Patch,
    Post,
    Request,
    UseGuards,
} from '@nestjs/common';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { SubscriptionService } from '../service/subscription.service';

@Controller('channels')
export class SubscriptionController {
    constructor(private readonly subscriptionService: SubscriptionService) {}

    // Toggle đăng ký / hủy đăng ký kênh (JWT required)
    @Post(':channelId/subscribe')
    @UseGuards(JwtAuthGuard)
    subscribe(@Request() req: any, @Param('channelId') channelId: string) {
        return this.subscriptionService.subscribeToggle(req.user.user_id, channelId);
    }

    // Xem trạng thái đăng ký của mình với kênh này (JWT required)
    @Get(':channelId/subscription-status')
    @UseGuards(JwtAuthGuard)
    checkStatus(@Request() req: any, @Param('channelId') channelId: string) {
        return this.subscriptionService.isSubscribed(req.user.user_id, channelId);
    }

    // Lấy danh sách subscriber của một kênh (public)
    @Get(':channelId/subscribers')
    getSubscribers(@Param('channelId') channelId: string) {
        return this.subscriptionService.getSubscribers(channelId);
    }

    // Lấy danh sách kênh mình đang subscribe (JWT required)
    @Get('subscriptions/mine')
    @UseGuards(JwtAuthGuard)
    getMySubscriptions(@Request() req: any) {
        return this.subscriptionService.getSubscribedChannels(req.user.user_id);
    }

    // Bật/tắt thông báo cho kênh đang subscribe (JWT required)
    @Patch(':channelId/notify')
    @UseGuards(JwtAuthGuard)
    toggleNotify(@Request() req: any, @Param('channelId') channelId: string) {
        return this.subscriptionService.toggleNotify(req.user.user_id, channelId);
    }
}
