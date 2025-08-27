import 'package:flutter/material.dart';
import 'package:trachtenberg_math/services/firebase_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Master Mental Math',
      'description': 'Learn the Trachtenberg method to solve complex multiplications in seconds!',
      'color': Color(0xFF6ECCAF),
    },
    {
      'title': 'Game-Based Learning',
      'description': 'Earn badges and climb leaderboards as you master each technique',
      'color': Color(0xFFFFD966),
    },
    {
      'title': 'Start Your Journey',
      'description': 'Create an account to save your progress across devices',
      'color': Color(0xFFE16262),
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _pages.length,
              itemBuilder: (context, index) => _buildPage(_pages[index]),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildPage(Map<String, dynamic> page) {
    return Container(
      color: page['color'],
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            page['title'],
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            page['description'],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () async {
                if (_currentPage < _pages.length - 1) {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  await FirebaseService.signInWithGoogle();
                }
              },
              child: Text(
                _currentPage == _pages.length - 1 
                  ? 'Sign In with Google' 
                  : 'Continue',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            ),
            child: const Text('Skip for now'),
          ),
        ],
      ),
    );
  }
}