import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Channel } from './entities/channel.entity';
import { Subscription } from './entities/subsciption.entity';
import { ChannelService } from './service/channel.service';
import { SubscriptionService } from './service/subscription.service';
import { ChannelController } from './controller/channel.controller';
import { SubscriptionController } from './controller/subscription.controller';

@Module({
    imports: [TypeOrmModule.forFeature([Channel, Subscription])],
    providers: [ChannelService, SubscriptionService],
    controllers: [ChannelController, SubscriptionController],
    exports: [ChannelService, TypeOrmModule],
})
export class ChannelModule {}
