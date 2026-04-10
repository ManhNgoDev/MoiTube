import { Body, Controller, Get, Post, Query } from '@nestjs/common';
import { AuthService } from '../service/auth.service';
import { RegisterDto } from '../dto/register.dto';
import { LoginDto } from '../dto/login.dto';
import { ResendDto } from '../dto/resend.dto';
import { ForgotPasswordDto, ResetPasswordDto } from '../dto/forgot-password.dto';



@Controller('auth')
export class AuthController {

  constructor(private authService: AuthService) { }

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

  @Post('resend-verify')
  resendVerification(@Body() body: ResendDto) {
    return this.authService.resendverification(body.email);
  };

  @Post('refresh')
  refresh(@Body('refresh_token') token: string) {
    return this.authService.refreshToken(token);
  }

  @Post('logout')
  logout(@Body('refresh_token') token: string) {
    return this.authService.logout(token);
  }

  @Post('forgot-password')
  forgotPassword(@Body() body: ForgotPasswordDto) {
    return this.authService.forgotPassword(body.email);
  }

  @Post('reset-password')
  resetPassword(@Body() body: ResetPasswordDto) {
    return this.authService.resetPassword(body.email, body.otp, body.password);
  }
}