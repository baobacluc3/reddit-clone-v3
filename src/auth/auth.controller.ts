import { Body, Controller, Get, Post, Req, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { JwtGuard } from './guards/jwt.guard';
import { CurrentUser } from './decorators/current-user.decorator';

@Controller('auth')
export class AuthController {
  constructor(private authSerivce: AuthService) {}

  @Post('register')
  register(@Body() dto: RegisterDto) {
    return this.authSerivce.register(dto);
  }

  @Post('login')
  login(@Body() dto: LoginDto) {
    return this.authSerivce.login(dto);
  }

  @Get('me')
  @UseGuards(JwtGuard)
  getMe(@CurrentUser('userId') userId: number) {
    return userId;
  }
}
