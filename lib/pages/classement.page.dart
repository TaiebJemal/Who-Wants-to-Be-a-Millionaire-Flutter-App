import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../Languages/app_localizations.dart';

class ClassementPage extends ConsumerStatefulWidget {
  const ClassementPage({super.key});

  @override
  ConsumerState<ClassementPage> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<ClassementPage> {
  Map<String, dynamic> _scores = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scoresString = prefs.getString('best_scores');
      setState(() {
        _scores = scoresString != null ? json.decode(scoresString) : {};
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading scores: $e')),
      );
    }
  }

  Future<void> _resetScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('best_scores');
      setState(() {
        _scores = {};
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error resetting scores: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final sortedScores = _scores.entries.toList()
      ..sort((a, b) => (b.value as num).compareTo(a.value as num));

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.ranking,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            tooltip: localizations.resetScores,
            onPressed: () {
              _showResetDialog();
            },
          ),
        ],
      ),
      backgroundColor: backgroundColor, // Set background based on theme
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.blue, // Consistent blue loading indicator
        ),
      )
          : _scores.isEmpty
          ? Center(
        child: Text(
          localizations.noScores,
          style: TextStyle(
            color: textColor, // Adapt to theme
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : ListView.builder(
        itemCount: sortedScores.length,
        itemBuilder: (context, index) {
          final entry = sortedScores[index];
          final cardColor = isDarkMode
              ? Colors.grey[900]!.withOpacity(0.8)
              : Colors.white;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.blue, // Blue border for both themes
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                entry.key,
                style: TextStyle(
                  color: textColor, // Adapt to theme
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${localizations.bestScore}: ${entry.value}',
                style: TextStyle(
                  color: textColor.withOpacity(0.7), // Slightly transparent
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '#${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showResetDialog() {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        title: Text(
          localizations.resetScores,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          localizations.confirmReset,
          style: TextStyle(
            color: textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              localizations.cancel,
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _resetScores();
              Navigator.pop(context);
            },
            child: Text(
              localizations.reset,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}