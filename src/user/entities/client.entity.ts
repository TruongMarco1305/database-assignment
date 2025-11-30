export enum MembershipTier {
  BRONZE = 'BRONZE',
  SILVER = 'SILVER',
  GOLD = 'GOLD',
  PLATINUM = 'PLATINUM',
}

export class Client {
  public user_id: Buffer;
  public slug: string;
  public membership_points: number;
  public membership_tier: MembershipTier;
}
