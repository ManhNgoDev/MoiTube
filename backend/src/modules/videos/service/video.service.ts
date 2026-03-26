import { BadRequestException, Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { Video, VideoStatus } from "../entities/video.entity";
import { Repository } from "typeorm";
import { CloudinaryService } from "../../cloudinary/service/cloudinary.service";
import { ChannelService } from "../../channel/service/channel.service";
import { CreateVideoDto } from "../dto/create_video.dto";

@Injectable()
export class VideoService {
    constructor(
        @InjectRepository(Video)
        private readonly videoRepo: Repository<Video>,
        private readonly cloudinaryService: CloudinaryService,
        private readonly channelService: ChannelService
    ) { }

    async createVideo(
        userId: string,
        dto: CreateVideoDto,
        videoFile?: Express.Multer.File,
        thumbnailFile?: Express.Multer.File
    ): Promise<Video> {
        const channel = await this.channelService.findById(userId);

        const videoResult = await this.cloudinaryService.uploadVideo(videoFile!)

        const duration = videoResult['duration']

        if (duration > 15 * 60) {
            await this.cloudinaryService.deleteFile(videoResult.public_id, 'video')
            throw new BadRequestException('Video không được vượt quá 15 phút')
        }

        let thumbnailUrl: string | undefined = undefined;
        if (thumbnailFile) {
            const thumbResult = await this.cloudinaryService.uploadImage(
                thumbnailFile,
                'moitube/thumbnails',
            );
            thumbnailUrl = thumbResult.secure_url;
        }

        const videoEntity = this.videoRepo.create({
            channel,
            title: dto.title,
            description: dto.description,
            video_url: videoResult.secure_url,
            thumbnail_url: thumbnailUrl,
            duration: Math.round(duration),
            status: dto.status || VideoStatus.PUBLIC,
            published_at: new Date(),
        });

        const savedVideo = await this.videoRepo.save(videoEntity);
        
        // Tăng video_count của channel
        await this.channelService.incrementVideoCount(channel.id, 1);

        return savedVideo;
    }

    
}