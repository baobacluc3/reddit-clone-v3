import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';

@Controller('auth')
export class AuthController {
  constructor(private authSerivce: AuthService) {}

  @Post('register')
  register(@Body() dto: RegisterDto) {
    return this.authSerivce.register(dto);
  }
}
