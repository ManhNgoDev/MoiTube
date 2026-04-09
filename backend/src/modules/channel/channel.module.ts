import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Channel } from './entities/channel.entity';
import { Subscription } from './entities/subsciption.entity';
import { ChannelService } from './service/channel.service';
import { SubscriptionService } from './service/subscription.service';
import { ChannelController } from './controller/channel.controller';
import { SubscriptionController } from './controller/subscription.controller';

import { User } from '../user/entities/user.entity';
import { CloudinaryModule } from '../cloudinary/cloudinary.module';
import { NotificationModule } from '../notification/notification.module';

@Module({
    imports: [
        TypeOrmModule.forFeature([Channel, Subscription, User]),
        CloudinaryModule,
        NotificationModule
    ],

    providers: [ChannelService, SubscriptionService],
    controllers: [ChannelController, SubscriptionController],
    exports: [ChannelService, SubscriptionService, TypeOrmModule],
})
export class ChannelModule {}
