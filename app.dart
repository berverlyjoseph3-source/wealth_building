import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trachtenberg_math/models/progress_model.dart';
import 'package:trachtenberg_math/screens/dashboard_screen.dart';
import 'package:trachtenberg_math/screens/onboarding_screen.dart';
import 'package:trachtenberg_math/screens/profile_screen.dart';
import 'package:trachtenberg_math/screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrachtenbergApp extends StatelessWidget {
  const TrachtenbergApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trachtenberg Math Master',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Nunito',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: Consumer<User?>(
        builder: (context, user, _) => 
          user == null ? const OnboardingScreen() : const MainNavigation(),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}