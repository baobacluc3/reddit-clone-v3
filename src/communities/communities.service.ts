import {
  BadRequestException,
  ConflictException,
  Injectable,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreateCommunityDto } from './dto/create-community.dto';
import { CommunityVisibility } from 'src/generated/prisma/enums';
import { Prisma } from 'src/generated/prisma/client';

const RESERVED_NAMES = new Set(['admin', 'api', 'auth', 'popular', 'all']);

@Injectable()
export class CommunitiesService {
  constructor(private prisma: PrismaService) {}

  async create(dto: CreateCommunityDto, userId: number) {
    if (RESERVED_NAMES.has(dto.name.toLowerCase())) {
      throw new BadRequestException(`"${dto.name}" is a reserved name`);
    }

    try {
      return await this.prisma.community.create({
        data: {
          name: dto.name,
          description: dto.description,
          visibility: dto.visibility ?? CommunityVisibility.PUBLIC,
          createdById: userId,
        },
        inclue: { createdBy: { select: { id: true, username: true } } },
      });
    } catch (e) {
      // P2002 = unique constraint violation
      if (
        e instanceof Prisma.PrismaClientKnownRequestError &&
        e.code === 'P2002'
      ) {
        throw new ConflictException('community already exists');
      }
      throw e;
    }
  }
}
