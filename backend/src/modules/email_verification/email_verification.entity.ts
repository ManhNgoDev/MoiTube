import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { User } from "../user/user.entity";

@Entity('email_verification')
export class Email_Verification {
    @PrimaryGeneratedColumn('uuid')
    id!: string;

    @ManyToOne(() => User, {onDelete: 'CASCADE'})
    @JoinColumn({name: 'user_id'})
    user!: User;

    @Column({unique: true, nullable: false})
    token!: string;

    @Column({default: false})
    used!: boolean;

    @Column({ type: 'timestamp' })
    expires_at!: Date;

    @CreateDateColumn()
    created_at!: Date;

}