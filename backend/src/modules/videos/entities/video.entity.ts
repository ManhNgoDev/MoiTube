import { Column, CreateDateColumn, Entity, Index, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { Channel } from "../../channel/entities/channel.entity";

export enum VideoStatus {
    UPLOADING = 'uploading',
    PUBLIC = 'public',
    PRIVATE = 'private'
}

@Index('idx_videos_channel_id', ['channel'])
@Index('idx_videos_status', ['status'])
@Index('idx_videos_published_at', ['published_at'])
@Index('idx_videos_channel_status', ['channel', 'status', 'published_at'])

@Entity('videos')
export class Video {
    @PrimaryGeneratedColumn('uuid')
    id!: string;

    @ManyToOne(() => Channel, {onDelete: 'CASCADE'})
    @JoinColumn({name: 'channel_id'})
    channel!: Channel;

    @Column({nullable: false})
    title!: string;

    @Column({nullable: true})
    description!: string;

    @Column({nullable: true})
    thumbnail_url!: string;

    @Column({nullable: true})
    video_url!: string;

    @Column({nullable: true})
    duration!: number;

    @Column({
        type: 'enum',
        enum: VideoStatus,
        default: VideoStatus.UPLOADING
    })
    status!: VideoStatus;

    @Column({default: 0})
    video_count!: number;

    @Column({default: 0})
    like_count!: number;

    @Column({default: 0})
    dislike_count!: number;

    @Column({default: 0})
    comment_count!: number;

    @Column({nullable: true})
    published_at!: Date;

    @CreateDateColumn()
    created_at!: Date
}