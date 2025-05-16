import 'package:flutter/material.dart';
import 'package:wwbm/services/quiz_service.dart';

class SettingsWidget extends StatefulWidget {
  final VoidCallback onThemeChanged;

  const SettingsWidget({super.key, required this.onThemeChanged});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool isDarkMode = false;
  bool soundEnabled = true;
  bool vibrationEnabled = true;
  String selectedLanguage = 'English';
  int numberOfQuestions = 10;
  String selectedCategory = 'General Knowledge';
  String selectedDifficulty = 'medium';

  final List<String> categories = [
    'Any Category', 'General Knowledge', 'Entertainment: Books', 'Entertainment: Film',
    'Entertainment: Music', 'Entertainment: Musicals & Theatres', 'Entertainment: Television',
    'Entertainment: Video Games', 'Entertainment: Board Games', 'Science & Nature',
    'Science: Computers', 'Science: Mathematics', 'Mythology', 'Sports', 'Geography',
    'History', 'Politics', 'Art', 'Celebrities', 'Animals', 'Vehicles', 'Entertainment: Comics',
    'Science: Gadgets', 'Entertainment: Japanese Anime & Manga', 'Entertainment: Cartoon & Animations'
  ];

  final List<String> difficulties = ['easy', 'medium', 'hard'];
  final List<int> questionCounts = [8, 10, 12, 15];
  final List<String> languages = ['English', 'Français'];

  void _updateFinalUrl() {
    final url = QuizService.buildApiUrl(
      amount: numberOfQuestions,
      category: QuizService.categories[selectedCategory],
      difficulty: selectedDifficulty,
    );
    QuizService.finalQuizUrl = url; // Share the final URL globally
  }

  @override
  void initState() {
    super.initState();
    _updateFinalUrl(); // Initial setup
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: isDarkMode,
              onChanged: (value) {
                setState(() => isDarkMode = value);
                widget.onThemeChanged();
              },
            ),
            SwitchListTile(
              title: const Text('Sound Effects'),
              value: soundEnabled,
              onChanged: (value) => setState(() => soundEnabled = value),
            ),
            SwitchListTile(
              title: const Text('Vibration'),
              value: vibrationEnabled,
              onChanged: (value) => setState(() => vibrationEnabled = value),
            ),
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              items: languages.map((lang) => DropdownMenuItem(value: lang, child: Text(lang))).toList(),
              onChanged: (value) => setState(() => selectedLanguage = value!),
              decoration: const InputDecoration(labelText: 'Language'),
            ),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
              onChanged: (value) {
                setState(() => selectedCategory = value!);
                _updateFinalUrl();
              },
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            DropdownButtonFormField<String>(
              value: selectedDifficulty,
              items: difficulties.map((dif) => DropdownMenuItem(value: dif, child: Text(dif))).toList(),
              onChanged: (value) {
                setState(() => selectedDifficulty = value!);
                _updateFinalUrl();
              },
              decoration: const InputDecoration(labelText: 'Difficulty'),
            ),
            DropdownButtonFormField<int>(
              value: numberOfQuestions,
              items: questionCounts.map((count) => DropdownMenuItem(value: count, child: Text('$count Questions'))).toList(),
              onChanged: (value) {
                setState(() => numberOfQuestions = value!);
                _updateFinalUrl();
              },
              decoration: const InputDecoration(labelText: 'Number of Questions'),
            ),
          ],
        ),
      ),
    );
  }
}
