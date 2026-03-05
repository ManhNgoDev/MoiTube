import { IsEmail, IsEmpty, IsNotEmpty, MinLength } from "class-validator";

export class RegisterDto {

    @IsEmail()
    email!: string;

    @IsNotEmpty()
    username!: string;

    @MinLength(8)
    password!: string; 
}