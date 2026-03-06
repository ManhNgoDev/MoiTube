import { BadRequestException, ConflictException, Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User, UserRole } from '../user/user.entity';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { Email_Verification } from '../email_verification/email_verification.entity';
import { EmailService } from '../email/email.service';
import { randomBytes } from 'crypto';

@Injectable()
export class AuthService {
    constructor(
        @InjectRepository(User)
        private userRepo: Repository<User>,
        @InjectRepository(Email_Verification)
        private verificationRepo: Repository<Email_Verification>,
        private jwtService: JwtService,
        private emailService: EmailService,
    ) {}
    //RREGISTER-------------------------------------------------------
    async register(email: string, username: string, password: string) {
        const existingUser = await this.userRepo.findOne({ where: [{ email }, { username }] });

        if(existingUser) {
            throw new ConflictException('Email hoặc username đã tồn tại');
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const newUser = this.userRepo.create({
            email,
            username,
            password_hash: hashedPassword,
            role: UserRole.USER,
        });

        await this.userRepo.save(newUser);

        await this.sendVerificationEmail(newUser);

        return {
            message: 'Đăng ký thành công',
            user: {
                id: newUser.id,
                email: newUser.email,
                username: newUser.username,
            },
        };
    };
    //LOGIN----------------------------------------------------------------------
    async login(email: string, password: string) {
        const user = await this.userRepo.findOne({where: {email}});

        if(!user) {
            throw new UnauthorizedException('Email hoặc mật khẩu không đúng');
        };

        if(!user.password_hash) {
            throw new UnauthorizedException('Email hoặc mật khẩu không đúng');
        };

        const isPasswordValid = await bcrypt.compare(password, user.password_hash);

        if(!isPasswordValid) {
            throw new UnauthorizedException('Email hoặc mật khẩu không đúng');
        };

        if(!user.is_verified) {
            throw new UnauthorizedException('Vui lòng xác nhận Email trước khi đăng nhập')
        };

        const payload = { sub: user.id, email: user.email, role: user.role };

        const access_token = this.jwtService.sign(payload, {
            expiresIn: '15m'
        });

        const refresh_token = this.jwtService.sign(payload, {
            secret: process.env.JWT_REFRESH_SECRET,
            expiresIn: '7d'
        });

        return {
            message: 'Đăng nhập thành công',
            access_token,
            refresh_token,
            user: {
                id: user.id,
                email: user.email,
                username: user.username,
                role: user.role
            },
        };
    };
    //VERYFY EMAIL-------------------------------------------------------------
    async verifyEmail(token: string) {
        const verification = await this.verificationRepo.findOne({ where: {token}, relations: ['user']});

        if(!verification) {
            throw new BadRequestException('Token không hợp lệ');
        };

        if(verification.used) {
            throw new BadRequestException('Token đã được sử dụng');
        };

        if(new Date() > verification.expires_at) {
            throw new BadRequestException('Token này đã hết hạn. Vui lòng gửi lại yêu cầu xác thực Email');
        };

        verification.used = true;

        await this.verificationRepo.save(verification);

        verification.user.is_verified = true;

        await this.userRepo.save(verification.user);

        return {
            message: 'Xác nhận Email thành công. Bạn có thể đăng nhập ngay'
        };
    };
    //RESEND VERIFY-----------------------------------------------------------
    async resendverification(email: string) {
        const user = await this.userRepo.findOne({where: {email}});

        if(!user) {
            return {message: 'Nếu email tôn tại, chúng tôi đã gửi email xác nhận cho bạn'};
        };

        if(!user.is_verified) {
            throw new BadRequestException('Email này đã nhận được rồi');
        };

        await this.resendverification(user.email);

        return {
            message: 'Nếu email này tồn tại, chúng tôi đã gửi lại email xâc nhận cho bạn'
        };
    };
    //HELPER
    private async sendVerificationEmail(user: User) {
        await this.verificationRepo.delete({ user_id: user.id, used: false});

        const token = randomBytes(32).toString('hex');

        const expires_at = new Date(Date.now() + 24 * 60 * 60 * 1000);

        const verification = this.verificationRepo.create({
            user_id: user.id,
            token,
            expires_at,
        });

        await this.verificationRepo.save(verification);

        await this.emailService.sendVerificationEmail(user.email, token);
    };
}
