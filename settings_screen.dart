import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _animationsEnabled = true;
  bool _darkMode = false;

  void _showPrivacyPolicy() async {
    const privacyUrl = 'https://ksah.co.uk/privacy';
    if (await canLaunch(privacyUrl)) {
      await launch(privacyUrl);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Privacy Policy'),
          content: const Text('You can view our privacy policy at $privacyUrl'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Enable Sound Effects'),
            value: _soundEnabled,
            onChanged: (value) => setState(() => _soundEnabled = value),
          ),
          SwitchListTile(
            title: const Text('Enable Animations'),
            value: _animationsEnabled,
            onChanged: (value) => setState(() => _animationsEnabled = value),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (value) => setState(() => _darkMode = value),
          ),
          const Divider(height: 40),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: _showPrivacyPolicy,
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              // TODO: Implement help screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Rate the App'),
            onTap: () {
              // TODO: Launch Play Store
            },
          ),
          const Divider(height: 40),
          if (user != null)
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: () => FirebaseAuth.instance.signOut(),
              ),
            ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Trachtenberg Math Master v1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}