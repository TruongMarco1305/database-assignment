export class Client {
  public userId: string;
  public slug: string;
  public membership_points: number;
  public membership_tier: string;

  constructor(userId: string, slug: string, points: number, tier: string) {
    this.userId = userId;
    this.slug = slug;
    this.membership_points = points;
    this.membership_tier = tier;
  }
}
