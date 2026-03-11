import {
    Body,
    Controller,
    Get,
    Param,
    Patch,
    Request,
    UseGuards,
} from '@nestjs/common';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { ChannelService } from '../service/channel.service';
import { UpdateChannelDto } from '../dto/update_channel.dto';

@Controller('channels')
export class ChannelController {
    constructor(private readonly channelService: ChannelService) {}

    // Xem channel của chính mình (JWT required)
    @Get('me')
    @UseGuards(JwtAuthGuard)
    getMyChannel(@Request() req: any) {
        return this.channelService.findById(req.user.user_id);
    }

    // Xem channel theo handle (public)
    @Get(':handle')
    getChannelByHandle(@Param('handle') handle: string) {
        return this.channelService.findByHandle(handle);
    }

    // Cập nhật thông tin channel của mình (JWT required)
    @Patch('me')
    @UseGuards(JwtAuthGuard)
    async updateMyChannel(@Request() req: any, @Body() dto: UpdateChannelDto) {
        const channel = await this.channelService.findById(req.user.user_id);
        return this.channelService.updateChannel(channel.id, req.user.user_id, dto);
    }
}
