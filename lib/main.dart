import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wwbm/theme/app_colors.dart';
import 'package:wwbm/pages/welcome.page.dart';
import 'package:wwbm/pages/question.page.dart';
import 'package:wwbm/widgets/settings.widget.dart';

void main() {
  runApp(MillionaireApp());
}

class MillionaireApp extends StatefulWidget {
  @override
  _MillionaireAppState createState() => _MillionaireAppState();
}

class _MillionaireAppState extends State<MillionaireApp> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  _toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = !isDarkMode;
    });
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: WelcomePage(
        isDarkMode: isDarkMode,
        onThemeChanged: _toggleTheme,
      ),
      routes: {
        '/questions': (context) => const QuestionPage(),


      },
    );
  }
}
