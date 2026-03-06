import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { User } from "../user/user.entity";

@Entity('refresh_tokens')
export class Refresh_Tokens {
    @PrimaryGeneratedColumn('uuid')
    id!: string;

    @ManyToOne(() => User, {onDelete: 'CASCADE'})
    @JoinColumn({name: 'user_id'})
    user!: User;

    @Column({name: 'user_id'})
    user_id!: string;

    @Column({unique: true, nullable: false})
    token_hash!: string;

    @Column({type: 'timestamp'})
    expires_at!: Date;

    @Column({default: false})
    revoked!: boolean;

    @CreateDateColumn()
    created_at!: Date;

}