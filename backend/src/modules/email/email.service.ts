import { Injectable } from '@nestjs/common';
import * as nodemailer from 'nodemailer'

@Injectable()
export class EmailService {
    private transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: process.env.GMAIL_USER,
            pass: process.env.GMAIL_APP_PASSWORD,
        },
    });

    async sendVerificationEmail(email: string, token: string) {
        const verifyUrl = `${process.env.APP_URL}/auth/verify?token=${token}`;

        await this.transporter.sendMail({
            from: `"MoiTube" <${process.env.GMAIL_USER}>`,
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
}
