import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, PrimaryColumn } from 'typeorm';
import { User } from '../../user/entities/user.entity';
import { Video } from './video.entity';

export enum VideoLikeType {
  LIKE = 'like',
  DISLIKE = 'dislike',
}

@Entity('video_likes')
export class VideoLike {
  @PrimaryColumn()
  user_id!: string;

  @PrimaryColumn()
  video_id!: string;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user!: User;

  @ManyToOne(() => Video, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'video_id' })
  video!: Video;

  @Column({
    type: 'enum',
    enum: VideoLikeType,
  })
  type!: VideoLikeType;

  @CreateDateColumn({ type: 'timestamp' })
  created_at!: Date;
}

