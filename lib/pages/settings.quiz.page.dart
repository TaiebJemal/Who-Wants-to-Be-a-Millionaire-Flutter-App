import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Languages/app_localizations.dart';
import 'quiz.page.dart';
import 'settings.provider.dart';
import 'dart:ui';
import 'package:just_audio/just_audio.dart';

class QuizParametersScreen extends ConsumerStatefulWidget {
  const QuizParametersScreen({super.key});

  @override
  ConsumerState<QuizParametersScreen> createState() => _QuizParametersScreenState();
}

class _QuizParametersScreenState extends ConsumerState<QuizParametersScreen> {
  List<String> _categories = [];
  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];
  final List<int> _questionNumbers = [5, 10, 15, 20];
  String? _selectedCategory;
  String? _selectedDifficulty;
  int _selectedQuestionNumber = 10;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isCountingDown = false;

  @override
  void initState() {
    super.initState();
    _selectedDifficulty = _difficulties[0];
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    const url = 'https://opentdb.com/api_category.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }

      final data = json.decode(response.body);
      final List<dynamic> categoryList = data['trivia_categories'];

      setState(() {
        _categories = categoryList.map((cat) => cat['name'] as String).toList();
        if (_categories.isNotEmpty) {
          _selectedCategory = _categories[0];
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(localizations.selectParameters),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(localizations.selectParameters),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(localizations.errorFetching),
              Text(_errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchCategories,
                child: Text(localizations.retry),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.selectParameters,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Sound toggle icon
          IconButton(
            icon: Icon(
              settings.soundEnabled ? Icons.volume_up : Icons.volume_off,
              color: Colors.white,
            ),
            onPressed: () {
              final newValue = !settings.soundEnabled;
              ref.read(settingsProvider.notifier).toggleSound(newValue);
            },
          ),

          // Dark mode toggle icon
          IconButton(
            icon: Icon(
              settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
            ),
            onPressed: () {
              final newValue = !settings.isDarkMode;
              ref.read(settingsProvider.notifier).toggleDarkMode(newValue);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.5)
                        : Colors.white.withOpacity(0.9), // White background in light mode
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Visibility(
                    visible: !_isCountingDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Category Dropdown
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: localizations.category,
                            labelStyle: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black, // Black text in light mode
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.8)
                                : Colors.grey[200], // Light grey in light mode
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black, // Black border in light mode
                              ),
                            ),
                          ),
                          value: _selectedCategory,
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black, // Black text in light mode
                            fontSize: 16,
                          ),
                          dropdownColor: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white, // White dropdown in light mode
                          isExpanded: true,
                          items: _categories
                              .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              category,
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black, // Black text in light mode
                                fontSize: 16,
                              ),
                            ),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Difficulty Dropdown
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: localizations.difficulty,
                            labelStyle: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.8)
                                : Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          value: _selectedDifficulty,
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            fontSize: 16,
                          ),
                          dropdownColor: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
                          isExpanded: true,
                          items: _difficulties
                              .map((difficulty) => DropdownMenuItem(
                            value: difficulty,
                            child: Text(
                              difficulty,
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDifficulty = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Number of Questions Dropdown
                        DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            labelText: localizations.numQuestions,
                            labelStyle: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.8)
                                : Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          value: _selectedQuestionNumber,
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            fontSize: 16,
                          ),
                          dropdownColor: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
                          isExpanded: true,
                          items: _questionNumbers
                              .map((number) => DropdownMenuItem(
                            value: number,
                            child: Text(
                              number.toString(),
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedQuestionNumber = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 24),

                        // Start Quiz Button
                        ElevatedButton(
                          onPressed: () {
                            if (_selectedCategory != null && _selectedDifficulty != null) {
                              setState(() {
                                _isCountingDown = true;
                              });
                              _showCountdownDialog(
                                context,
                                    () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuizScreen(
                                        category: _selectedCategory!,
                                        difficulty: _selectedDifficulty!,
                                        numberOfQuestions: _selectedQuestionNumber,
                                      ),
                                    ),
                                  ).then((_) {
                                    setState(() {
                                      _isCountingDown = false;
                                    });
                                  });
                                },
                                settings.soundEnabled,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            localizations.startQuiz,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCountdownDialog(BuildContext context, VoidCallback onCountdownComplete, bool isSoundEnabled) {
    int countdown = 3;
    final player = AudioPlayer(); // Create an audio player instance

    // Play the countdown audio if sound is enabled
    if (isSoundEnabled) {
      player.setAsset('assets/audio/countdown.mp3').then((_) {
        player.play();
      });
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Start the countdown
            Future.delayed(const Duration(seconds: 1), () {
              if (countdown > 0) {
                setState(() {
                  countdown--;
                });
              } else {
                Navigator.of(context).pop(); // Close the dialog
                onCountdownComplete(); // Start the quiz
              }
            });

            return Dialog(
              backgroundColor: Colors.black.withOpacity(0.8), // Full-screen background
              insetPadding: EdgeInsets.zero, // Remove default padding
              child: Stack(
                children: [
                  // Countdown text in the center
                  Center(
                    child: Text(
                      countdown > 0 ? '$countdown' : 'Go!',
                      style: const TextStyle(
                        fontSize: 100, // Large font size for full-screen effect
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}