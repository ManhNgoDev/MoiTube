import {
    Body,
    Controller,
    Delete,
    Get,
    Patch,
    Request,
    UseGuards,
} from '@nestjs/common';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { UserService } from '../service/user.service';
import { UpdateUserDto } from '../dto/update_user.dto';
import { ChangePasswordDto } from '../dto/change_password.dto';

@Controller('users')
@UseGuards(JwtAuthGuard)
export class UserController {
    constructor(private readonly userService: UserService) {}

    @Get('me')
    getProfile(@Request() req: any) {
        return this.userService.getProfile(req.user.user_id);
    }

    @Patch('me')
    updateProfile(@Request() req: any, @Body() dto: UpdateUserDto) {
        return this.userService.updateProfile(req.user.user_id, dto);
    }

    @Patch('me/password')
    changePassword(@Request() req: any, @Body() dto: ChangePasswordDto) {
        return this.userService.changePassword(req.user.user_id, dto);
    }

    @Delete('me')
    deleteAccount(@Request() req: any) {
        return this.userService.deleteAccount(req.user.user_id);
    }
}
