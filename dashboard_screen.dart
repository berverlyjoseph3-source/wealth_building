import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trachtenberg_math/models/progress_model.dart';
import 'rule_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = Provider.of<ProgressTracker>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Trachtenberg Trainer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressHeader(progress),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                children: List.generate(12, (index) {
                  final rule = index + 2;
                  return _buildRuleCard(context, rule, progress);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader(ProgressTracker progress) {
    final completed = progress.progress.values
        .where((element) => element['completed'] == true)
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: completed / 12,
              minHeight: 20,
              borderRadius: BorderRadius.circular(10),
            const SizedBox(height: 10),
            Text('${(completed / 12 * 100).toStringAsFixed(1)}% Complete'),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleCard(BuildContext context, int rule, ProgressTracker progress) {
    final isCompleted = progress.progress['rule_$rule']?['completed'] ?? false;

    return Card(
      color: isCompleted ? Colors.teal.shade100 : null,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RuleScreen(rule: rule),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Multiply by $rule',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (isCompleted) ...[
              const SizedBox(height: 10),
              const Icon(Icons.check_circle, color: Colors.green),
            ]
          ],
        ),
      ),
    );
  }
  
  
  // Add to the build method:
Widget _buildStreakCard(ProgressTracker progress) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department, color: Colors.orange, size: 40),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Current Streak'),
              Text(
                '${progress.streak} days',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildBadges(ProgressTracker progress) {
  final badges = progress.unlockedBadges;
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Your Badges', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      badges.isEmpty
        ? const Text('Complete lessons to earn badges!')
        : Wrap(
            spacing: 10,
            children: badges.map((badge) => Chip(
              label: Text(badge),
              backgroundColor: Colors.amber[100],
            )).toList(),
          ),
    ],
  );
}

// Add to the body Column:
_buildStreakCard(progress),
const SizedBox(height: 20),
_buildBadges(progress),
}