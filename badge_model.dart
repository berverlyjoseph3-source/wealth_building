class Badge {
  final String id;
  final String title;
  final String description;
  final String iconAsset;
  final String unlockCondition;

  Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.iconAsset,
    required this.unlockCondition,
  });
}

class BadgeRepository {
  static List<Badge> getAllBadges() {
    return [
      Badge(
        id: 'bronze',
        title: 'Bronze Calculator',
        description: 'Complete 3 rules',
        iconAsset: 'assets/badges/bronze.png',
        unlockCondition: 'rules_completed >= 3',
      ),
      Badge(
        id: 'silver',
        title: 'Silver Strategist',
        description: 'Complete 6 rules',
        iconAsset: 'assets/badges/silver.png',
        unlockCondition: 'rules_completed >= 6',
      ),
      Badge(
        id: 'gold',
        title: 'Gold Genius',
        description: 'Complete 9 rules',
        iconAsset: 'assets/badges/gold.png',
        unlockCondition: 'rules_completed >= 9',
      ),
      Badge(
        id: 'master',
        title: 'Trachtenberg Master',
        description: 'Complete all 12 rules',
        iconAsset: 'assets/badges/master.png',
        unlockCondition: 'rules_completed == 12',
      ),
      Badge(
        id: 'streak7',
        title: 'Weekly Warrior',
        description: '7-day practice streak',
        iconAsset: 'assets/badges/streak.png',
        unlockCondition: 'streak >= 7',
      ),
      Badge(
        id: 'speedster',
        title: 'Speedster',
        description: 'Solve 10 problems in under 30 seconds',
        iconAsset: 'assets/badges/speed.png',
        unlockCondition: 'quiz_time < 30',
      ),
    ];
  }
}