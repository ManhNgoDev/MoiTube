import { Body, Controller, Get, Post, Query } from '@nestjs/common';
import { AuthService } from '../service/auth.service';
import { RegisterDto } from '../dto/register.dto';
import { LoginDto } from '../dto/login.dto';
import { ResendDto } from '../dto/resend.dto';



@Controller('auth')
export class AuthController {

  constructor(private authService: AuthService) {}

  @Post('register')
  register(@Body() body: RegisterDto) {
    return this.authService.register(
      body.email,
      body.username,
      body.password
    );
  };

  @Post('login')
  login(@Body() body: LoginDto) {
    return this.authService.login(
      body.email,
      body.password
    );
  };

  @Get('verify')
  verifyEmail(@Query('token') token: string) {
    return this.authService.verifyEmail(token);
  };

  @Get('resend-verify')
  resendVerification(@Body() body: ResendDto) {
    return this.authService.resendverification(body.email);
  };

  @Post('refresh')
    refresh(@Body('refresh_token') token: string) {
    return this.authService.refreshToken(token);
  }
}