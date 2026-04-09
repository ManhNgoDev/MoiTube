import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { User } from "../../user/entities/user.entity";

export enum NotificationType {
    NEW_VIDEO = 'new_video',
    COMMENT = 'comment',
    LIKE = 'like',
    SUBSCRIBE = 'subscribe'
}

@Entity('notifications')
export class Notification {
    @PrimaryGeneratedColumn('uuid')
    id!: string;

    @Column({
        type: 'enum',
        enum: NotificationType,
    })
    type!: NotificationType;

    @Column()
    user_id!: string;

    @Column()
    actor_id!: string;

    @Column({ nullable: true })
    resource_id?: string;

    @Column({ default: false })
    is_read!: boolean;

    @Column({ nullable: true })
    message?: string;

    @CreateDateColumn({ type: 'timestamp' })
    created_at!: Date;

    // Relations
    @ManyToOne(() => User)
    @JoinColumn({ name: 'user_id' })
    user!: User;

    @ManyToOne(() => User)
    @JoinColumn({ name: 'actor_id' })
    actor!: User;
}
