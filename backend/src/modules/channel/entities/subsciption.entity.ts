import { Column, CreateDateColumn, Entity, JoinColumn, ManyToMany, ManyToOne, PrimaryColumn, PrimaryGeneratedColumn } from "typeorm";
import { User } from "../../user/entities/user.entity";
import { Channel } from "./channel.entity";

@Entity('subscriptions')
export class Subscription {
    @PrimaryColumn()
  subscriber_id!: string;

  @PrimaryColumn()
  channel_id!: string;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'subscriber_id' })
  subscriber!: User;

  @ManyToOne(() => Channel, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'channel_id' })
  channel!: Channel;

  @Column({ default: true })
  notify_enabled!: boolean;

  @CreateDateColumn()
  subscribed_at!: Date;
}
