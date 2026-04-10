import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { WatchHistory } from './entities/watch_history.entity';
import { HistoryService } from './service/history.service';
import { HistoryController } from './controller/history.controller';
import { Video } from '../videos/entities/video.entity';

@Module({
    imports: [TypeOrmModule.forFeature([WatchHistory, Video])],
    providers: [HistoryService],
    controllers: [HistoryController],
    exports: [HistoryService],
})
export class HistoryModule {}
