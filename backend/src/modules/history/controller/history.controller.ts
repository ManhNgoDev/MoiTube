import { Controller, Delete, Get, Param, Post, Query, Req, UseGuards } from '@nestjs/common';
import { HistoryService } from '../service/history.service';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';

@Controller('history')
@UseGuards(JwtAuthGuard)
export class HistoryController {
    constructor(private readonly historyService: HistoryService) {}

    @Post(':videoId')
    addToHistory(@Req() req: any, @Param('videoId') videoId: string) {
        return this.historyService.addOrUpdateHistory(req.user.user_id, videoId);
    }

    @Get()
    getHistory(
        @Req() req: any,
        @Query('page') page: string,
        @Query('limit') limit: string
    ) {
        return this.historyService.getHistory(req.user.user_id, +page || 1, +limit || 20);
    }

    @Delete('clear')
    clearHistory(@Req() req: any) {
        return this.historyService.clearAllHistory(req.user.user_id);
    }

    @Delete(':videoId')
    removeHistoryItem(@Req() req: any, @Param('videoId') videoId: string) {
        return this.historyService.removeHistoryItem(req.user.user_id, videoId);
    }
}
