import { Injectable } from '@nestjs/common';
import * as nodemailer from 'nodemailer'

import { ConfigService } from '@nestjs/config';

@Injectable()
export class EmailService {
    constructor(private configService: ConfigService) {}

    private getTransporter() {
        const user = this.configService.get<string>('GMAIL_USER');
        const pass = this.configService.get<string>('GMAIL_APP_PASSWORD');
        
        if (!user || !pass) {
            return null;
        }
        return nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user,
                pass,
            },
        });
    }

    async sendVerificationEmail(email: string, token: string) {
        const appUrl = this.configService.get<string>('APP_URL') || 'http://localhost:3000';
        const verifyUrl = `${appUrl}/auth/verify?token=${token}`;
        const transporter = this.getTransporter();

        if (!transporter) {
            console.log('--- DEV EMAIL MODE ---');
            console.log(`To: ${email}`);
            console.log(`Verify URL: ${verifyUrl}`);
            console.log('-----------------------');
            return;
        }

        await transporter.sendMail({
            from: `"MoiTube" <${this.configService.get<string>('GMAIL_USER')}>`,
            to: email,
            subject: 'Xác nhận email đăng ký MoiTube',
            html: `
                <div style="font-family: sanf-serif; max-width: 480px; margin: auto;">
                <h2>Xác nhận Email của bạn </h2>
                <p>Click vào nút bên dưới để xác nhận email. Link có hiệu lực trong <strong style="color: red">24 giờ </strong>. </p>
                <a href="${verifyUrl}" 
                style="display:inline-block; padding: 12px 24px; background:#e53935; 
                        color:white; border-radius:6px; text-decoration:none; font-weight:bold;">
                Xác nhận email
                </a>
                <p style="margin-top:16px; color:#888; font-size:12px;">
                Nếu bạn không đăng ký, hãy bỏ qua Email này
                </p>
                </div>
            `,
        });
    };

    async sendPasswordResetOtpEmail(email: string, otp: string) {
        const transporter = this.getTransporter();

        if (!transporter) {
            console.log('--- DEV EMAIL MODE ---');
            console.log(`To: ${email}`);
            console.log(`Password Reset OTP: ${otp}`);
            console.log('-----------------------');
            return;
        }

        await transporter.sendMail({
            from: `"MoiTube" <${this.configService.get<string>('GMAIL_USER')}>`,
            to: email,
            subject: 'Khôi phục mật khẩu MoiTube',
            html: `
                <div style="font-family: sanf-serif; max-width: 480px; margin: auto;">
                <h2>Khôi phục mật khẩu của bạn</h2>
                <p>Bạn đã yêu cầu khôi phục mật khẩu. Dưới đây là mã xác thực OTP của bạn:</p>
                <div style="margin: 24px 0; font-size: 32px; font-weight: bold; letter-spacing: 4px; text-align: center; color: #e53935; background: #f5f5f5; padding: 16px; border-radius: 8px;">
                    ${otp}
                </div>
                <p>Mã này có hiệu lực trong <strong style="color: red">10 phút</strong>.</p>
                <p style="margin-top:16px; color:#888; font-size:12px;">
                Nếu bạn không yêu cầu khôi phục mật khẩu, vui lòng bỏ qua email này hoặc liên hệ hỗ trợ.
                </p>
                </div>
            `,
        });
    }
}
