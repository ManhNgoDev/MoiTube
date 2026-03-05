import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn } from "typeorm";

export enum UserRole {
    USER = 'user',
    CREATOR = 'creator',
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
        default: () => 'CURRENT_TIMESTAMP'
    })
    created_at!: Date;

    @CreateDateColumn({
        type: 'timestamp',
        default: () => 'CURRENT_TIMESTAMP',
        onUpdate: 'CURRENT_TIMESTAMP'
    })
    updated_at!: Date;
}