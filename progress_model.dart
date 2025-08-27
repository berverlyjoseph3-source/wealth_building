import 'package:flutter/material.dart';

class ProgressTracker extends ChangeNotifier {
  Map<String, dynamic> _progress = {};
  int _streak = 0;
  DateTime? _lastPracticeDate;

  Map<String, dynamic> get progress => _progress;
  int get streak => _streak;

  void updateRuleProgress(String rule, int score) {
    _progress[rule] = {
      'score': score,
      'completed': score >= 70,
      'timestamp': DateTime.now(),
    };
    
    // Update streak
    final today = DateTime.now();
    if (_lastPracticeDate == null || 
        today.difference(_lastPracticeDate!).inDays >= 1) {
      _streak++;
    } else if (today.difference(_lastPracticeDate!).inDays > 1) {
      _streak = 1; // Reset streak if skipped days
    }
    _lastPracticeDate = today;
    
    notifyListeners();
    
    // Save to Firebase (implemented earlier)
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseService.saveUserProgress(user.uid, {
        'progress': _progress,
        'streak': _streak,
        'lastPractice': _lastPracticeDate,
      });
    }
  }

  double get overallProgress {
    if (_progress.isEmpty) return 0;
    final completed = _progress.values.where((p) => p['completed']).length;
    return completed / 12;
  }

  List<String> get unlockedBadges {
    final badges = <String>[];
    final completed = _progress.values.where((p) => p['completed']).length;
    
    if (completed >= 3) badges.add('Bronze Calculator');
    if (completed >= 6) badges.add('Silver Strategist');
    if (completed >= 9) badges.add('Gold Genius');
    if (completed == 12) badges.add('Trachtenberg Master');
    if (_streak >= 7) badges.add('Weekly Warrior');
    
    return badges;
  }
}