import {
    BadRequestException,
    Injectable,
    NotFoundException,
    UnauthorizedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User } from '../entities/user.entity';
import { UpdateUserDto } from '../dto/update_user.dto';
import { ChangePasswordDto } from '../dto/change_password.dto';

@Injectable()
export class UserService {
    constructor(
        @InjectRepository(User)
        private readonly userRepo: Repository<User>,
    ) {}

    // Lấy thông tin profile (không trả về password_hash)
    async getProfile(userId: string) {
        const user = await this.userRepo.findOne({ where: { id: userId } });

        if (!user) throw new NotFoundException('Người dùng không tồn tại');

        const { password_hash, ...safeUser } = user;
        return safeUser;
    }

    // Cập nhật avatar
    async updateProfile(userId: string, dto: UpdateUserDto) {
        const user = await this.userRepo.findOne({ where: { id: userId } });

        if (!user) throw new NotFoundException('Người dùng không tồn tại');

        Object.assign(user, dto);
        await this.userRepo.save(user);

        const { password_hash, ...safeUser } = user;
        return safeUser;
    }

    // Đổi mật khẩu
    async changePassword(userId: string, dto: ChangePasswordDto) {
        const user = await this.userRepo.findOne({ where: { id: userId } });

        if (!user) throw new NotFoundException('Người dùng không tồn tại');

        if (!user.password_hash) {
            throw new BadRequestException(
                'Tài khoản này đăng nhập bằng Google, không thể đổi mật khẩu',
            );
        }

        const isValid = await bcrypt.compare(dto.old_password, user.password_hash);
        if (!isValid) {
            throw new UnauthorizedException('Mật khẩu cũ không đúng');
        }

        user.password_hash = await bcrypt.hash(dto.new_password, 10);
        await this.userRepo.save(user);

        return { message: 'Đổi mật khẩu thành công' };
    }

    // Xoá tài khoản
    async deleteAccount(userId: string) {
        const user = await this.userRepo.findOne({ where: { id: userId } });

        if (!user) throw new NotFoundException('Người dùng không tồn tại');

        await this.userRepo.remove(user);
        return { message: 'Tài khoản đã được xoá' };
    }
}
