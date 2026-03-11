import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { User } from "../../user/entities/user.entity";

@Entity('channels')
export class Channel {
    @PrimaryGeneratedColumn('uuid')
    id!: string;

    @ManyToOne(() => User, {onDelete: 'CASCADE'})
    @JoinColumn({name: 'user_id'})
    user!: User;

    @Column({unique: true, nullable: false})
    handle!: string;

    @Column({nullable: false})
    name!: string;

    @Column({nullable: true})
    description!: string;

    @Column({nullable: true})
    banner_url!: string;

    @Column({nullable: true})
    website_url!: string;

    @Column({type: 'jsonb', default: {}, nullable: true})
    social_link!: Record<string, string>;

    @Column({default: 0})
    subscriber_count!: number;

    @CreateDateColumn()
    created_at!: Date;
}