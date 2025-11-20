export class Client {
  public userId: string;
  public slug: string;
  public membership_points: number;
  public membership_tier: string;

  constructor(userId: string) {
    this.userId = userId;
    this.slug = `${Math.random().toString(36).substring(2, 8).toUpperCase()}`;
    this.membership_points = 0;
    this.membership_tier = 'BRONZE';
  }
}
