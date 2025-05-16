import 'package:flutter/material.dart';
import 'package:wwbm/widgets/settings.widget.dart';

class WelcomePage extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const WelcomePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: isDarkMode ? Colors.white : Colors.black),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => SettingsWidget(onThemeChanged: onThemeChanged),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_objects, size: 80, color: isDarkMode ? Colors.amber : Colors.blue),
            const SizedBox(height: 20),
            Text(
              'Who Wants to Be a Millionaire?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/questions');
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
