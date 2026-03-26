import { ConflictException, ForbiddenException, Injectable, NotFoundException } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { Channel } from "../entities/channel.entity";
import { Repository } from "typeorm";
import { User } from "../../user/entities/user.entity";
import { UpdateChannelDto } from "../dto/update_channel.dto";

@Injectable()
export class ChannelService {
    constructor(
        @InjectRepository(Channel)
        private channelRepo: Repository<Channel>,
        @InjectRepository(User)
        private userRepo: Repository<User>,
    ) {}

    //Hệ thống tự động tạo channel sau khi đăng ký tài khoản
    async createChannel(user: User) {
        const handle = user.username.toLowerCase().replace(/[^a-z0-9_]/g, '_')

        const channel = this.channelRepo.create({
            user,
            handle,
            name: user.username
        })

        return this.channelRepo.save(channel)
    }
    //Tìm Channel 
    async findByHandle(handle: string):Promise<Channel> {
        const channel = await this.channelRepo.findOne({
            where: {handle},
            relations: ['user']
        });

        if(!channel) throw new NotFoundException('Kênh không tồn tại');

        return channel;
    }
    //Tìm Channel ID
    async findById(userId: string): Promise<Channel> {
        let channel = await this.channelRepo.findOne({
            where: {user: {id: userId}},
            relations: ['user']
        })

        if(!channel) {
            // Nếu chưa có channel, tự động tạo mới (cho user cũ)
            const user = await this.userRepo.findOne({ where: { id: userId } });
            if (!user) throw new NotFoundException('Người dùng không tồn tại');
            channel = await this.createChannel(user);
            // Sau khi tạo xong, load lại relations để có user object đầy đủ
            return this.findById(userId);
        }
        
        return channel;
    }

    //Cập nhật thông tin channel
    async updateChannel(channelId: string, userId: string, dto: UpdateChannelDto): Promise<Channel> {
        const channel = await this.channelRepo.findOne({
            where: {id: channelId},
            relations: ['user']
        });

        if(!channel) throw new NotFoundException('Kênh không tồn tại');

        if(channel.user.id !== userId) throw new ForbiddenException('Bạn không có quyền chỉnh sửa kênh này');

        if(dto.handle && dto.handle !== channel.handle) {
            const existing = await this.channelRepo.findOne({
                where: {handle: dto.handle}
            });

            if(existing) throw new ConflictException('Handle này đã được sử dụng');
        }

        Object.assign(channel, dto);

        return this.channelRepo.save(channel);
    }
    //Tăng giảm subscriber_count
    async incrementSubscriber(channelId: string, delta: 1 | -1): Promise<void> {
        await this.channelRepo.increment(
            {id: channelId},
            'subscriber_count',
            delta
        )
    }

    async incrementVideoCount(channelId: string, delta: number): Promise<void> {
        await this.channelRepo.increment(
            {id: channelId},
            'video_count',
            delta
        )
    }

    async incrementViewCount(channelId: string, delta: number): Promise<void> {
        await this.channelRepo.increment(
            {id: channelId},
            'view_count',
            delta
        )
    }
}