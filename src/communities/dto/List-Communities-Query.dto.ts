export class ListCommunitiesQueryDto {
  search?: string;
  page?: number = 1;
  limit?: number = 20;
  sort?: number;
}
