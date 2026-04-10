import { IsEmail, IsNotEmpty, IsString, MinLength } from "class-validator";

export class ForgotPasswordDto {
    @IsEmail({}, { message: 'Email không hợp lệ' })
    @IsNotEmpty({ message: 'Vui lòng nhập email' })
    email!: string;
}

export class ResetPasswordDto {
    @IsEmail({}, { message: 'Email không hợp lệ' })
    @IsNotEmpty({ message: 'Vui lòng nhập email' })
    email!: string;

    @IsString()
    @IsNotEmpty({ message: 'Vui lòng nhập mã OTP' })
    otp!: string;

    @IsString()
    @IsNotEmpty({ message: 'Vui lòng nhập mật khẩu mới' })
    @MinLength(6, { message: 'Mật khẩu phải có ít nhất 6 ký tự' })
    password!: string;
}
