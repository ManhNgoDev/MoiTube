import {
    Body,
    Controller,
    Get,
    Param,
    Patch,
    Request,
    UploadedFiles,
    UseGuards,
    UseInterceptors,
} from '@nestjs/common';
import { FileFieldsInterceptor } from '@nestjs/platform-express';
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
    @UseInterceptors(FileFieldsInterceptor([
        { name: 'avatar', maxCount: 1 },
        { name: 'banner', maxCount: 1 },
    ]))
    async updateMyChannel(
        @Request() req: any, 
        @Body() dto: UpdateChannelDto,
        @UploadedFiles() files: { avatar?: Express.Multer.File[], banner?: Express.Multer.File[] }
    ) {
        const channel = await this.channelService.findById(req.user.user_id);
        return this.channelService.updateChannel(
            channel.id, 
            req.user.user_id, 
            dto, 
            files.avatar?.[0], 
            files.banner?.[0]
        );
    }
}
