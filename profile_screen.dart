import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trachtenberg_math/models/badge_model.dart';
import 'package:trachtenberg_math/models/progress_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = Provider.of<ProgressTracker>(context);
    final badges = BadgeRepository.getAllBadges();
    final unlockedBadges = progress.unlockedBadges;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/profile_placeholder.png'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      FirebaseAuth.instance.currentUser?.email ?? 'Guest',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('${progress.streak}', 'Day Streak'),
                        _buildStatItem(
                          '${(progress.overallProgress * 100).toInt()}%', 
                          'Mastery'
                        ),
                        _buildStatItem(
                          progress.totalProblemsSolved.toString(), 
                          'Problems Solved'
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            const Text(
              'Your Badges',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: badges.map((badge) {
                final isUnlocked = unlockedBadges.contains(badge.title);
                return Tooltip(
                  message: isUnlocked 
                    ? badge.description 
                    : 'Locked: ${badge.unlockCondition}',
                  child: Opacity(
                    opacity: isUnlocked ? 1.0 : 0.3,
                    child: Column(
                      children: [
                        Image.asset(badge.iconAsset, width: 60, height: 60),
                        Text(badge.title, textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}