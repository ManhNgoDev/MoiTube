import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";

export enum UserRole {
    USER = 'user',
    ADMIN = 'admin'
}

export enum AuthProvider {
    LOCAL = 'local',
    GOOGLE = 'google'
}

@Entity('users')
export class User {
    @PrimaryGeneratedColumn('uuid')
    id!: string;

    @Column({unique: true, nullable: false})
    email!: string;

    @Column({unique: true, nullable: false})
    username!: string;

    @Column({nullable: true})
    password_hash?: string;

    @Column({unique: true, nullable: true})
    google_id?: string;

    @Column({
        type: 'enum',
        enum: AuthProvider,
        default: AuthProvider.LOCAL
    })
    auth_provider!: AuthProvider;

    @Column({type: 'text', nullable: true})
    avatar_url!: string;

    @Column({
        type: 'enum',
        enum: UserRole,
        enumName: 'user_role_enum',
        default: UserRole.USER
    })
    role!: UserRole;
    
    @Column({default: false})
    is_verified!: boolean;

    @CreateDateColumn({
        type: 'timestamp',
    })
    created_at!: Date;

    @UpdateDateColumn({ type: 'timestamp' })
    updated_at!: Date;
}