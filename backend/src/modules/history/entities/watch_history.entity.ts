import { Column, CreateDateColumn, Entity, Index, JoinColumn, ManyToOne, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { User } from "../../user/entities/user.entity";
import { Video } from "../../videos/entities/video.entity";

@Entity('watch_history')
@Index('idx_watch_history_user_video', ['user_id', 'video_id'], { unique: true })
@Index('idx_watch_history_watched_at', ['watched_at'])
export class WatchHistory {
    @PrimaryGeneratedColumn('uuid')
    id!: string;

    @Column()
    user_id!: string;

    @Column()
    video_id!: string;

    @ManyToOne(() => User, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'user_id' })
    user!: User;

    @ManyToOne(() => Video, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'video_id' })
    video!: Video;

    @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
    watched_at!: Date;
}
