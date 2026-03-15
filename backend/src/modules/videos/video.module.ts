import { Module } from "@nestjs/common";
import { TypeOrmModule } from "@nestjs/typeorm";
import { Video } from "./entities/video.entity";
import { VideoController } from "./controller/video.controller";
import { VideoService } from "./service/video.service";
import { CloudinaryService } from "../cloudinary/service/cloudinary.service";
import { CloudinaryModule } from "../cloudinary/cloudinary.module";
import { ChannelModule } from "../channel/channel.module";

@Module({
    imports: [
        TypeOrmModule.forFeature([Video]),
        CloudinaryModule,
        ChannelModule],
    providers: [VideoService],
    controllers: [VideoController],
    exports: [VideoService]
})
export class VideoModule {}