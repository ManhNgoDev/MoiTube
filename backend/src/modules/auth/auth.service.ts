import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User, UserRole } from '../user/user.entity';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthService {
    constructor(
        @InjectRepository(User)
        private userRepo: Repository<User>,
        private jwtService: JwtService,
    ) {}

    async register(email: string, username: string, password_hash: string) {
        const existingUser = await this.userRepo.findOne({ where: [{ email }, { username }] });

        if(existingUser) {
            throw new Error('Email hoặc username đã tồn tại');
        }

        const hashedPassword = await bcrypt.hash(password_hash, 10);

        const newUser = this.userRepo.create({
            email,
            username,
            password_hash: hashedPassword,
            role: UserRole.USER,
        });

        await this.userRepo.save(newUser);

        return {
            message: 'Đăng ký thành công',
            user: {
                id: newUser.id,
                email: newUser.email,
                username: newUser.username,
            },
        };
    };
}
