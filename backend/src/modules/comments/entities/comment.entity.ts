import { Column, CreateDateColumn, Entity, Index, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { Video } from '../../videos/entities/video.entity';
import { User } from '../../user/entities/user.entity';

@Index('idx_comments_video_id_created_at', ['video', 'created_at'])
@Index('idx_comments_user_id', ['user'])
@Entity('comments')
export class Comment {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @ManyToOne(() => Video, { onDelete: 'CASCADE', nullable: false })
  @JoinColumn({ name: 'video_id' })
  video!: Video;

  @ManyToOne(() => User, { onDelete: 'CASCADE', nullable: false })
  @JoinColumn({ name: 'user_id' })
  user!: User;

  @ManyToOne(() => Comment, { onDelete: 'CASCADE', nullable: true })
  @JoinColumn({ name: 'parent_id' })
  parent?: Comment | null;

  @Column({ type: 'text', nullable: false })
  content!: string;

  @Column({ default: 0 })
  like_count!: number;

  @CreateDateColumn({ type: 'timestamp' })
  created_at!: Date;
}

