import { CommunityVisibility } from 'src/generated/prisma/enums';

export class CreateCommunityDto {
  name: string;
  description: string;
  visibility?: CommunityVisibility;
}
