import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Languages/app_localizations.dart';
import 'settings.provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    final Map<String, Locale> supportedLanguages = {
      'English': const Locale('en'),
      'Français': const Locale('fr'),
      'العربية': const Locale('ar'),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.settings,
          style: TextStyle(
            color: settings.isDarkMode ? Colors.white : Colors.white, // White text in both modes
          ),
        ),
        backgroundColor: Colors.blue, // Blue background in both modes
        iconTheme: IconThemeData(
          color: settings.isDarkMode ? Colors.white : Colors.white, // White icons in both modes
        ),
      ),
      body: Container(
        color: settings.isDarkMode ? Colors.grey[900] : Colors.white, // Dark grey in dark mode, white in light
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: settings.isDarkMode ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue, // Blue border in both modes
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: settings.isDarkMode
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.blue.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      title: Text(
                        localizations.darkMode,
                        style: TextStyle(
                          color: settings.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      value: settings.isDarkMode,
                      onChanged: notifier.toggleDarkMode,
                      activeColor: Colors.blue, // Blue switch in both modes
                    ),
                    SwitchListTile(
                      title: Text(
                        localizations.soundEffects,
                        style: TextStyle(
                          color: settings.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      value: settings.soundEnabled,
                      onChanged: notifier.toggleSound,
                      activeColor: Colors.blue, // Blue switch in both modes
                    ),
                    SwitchListTile(
                      title: Text(
                        localizations.notifications,
                        style: TextStyle(
                          color: settings.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      value: settings.notificationsEnabled,
                      onChanged: notifier.toggleNotifications,
                      activeColor: Colors.blue, // Blue switch in both modes
                    ),
                    ListTile(
                      title: Text(
                        localizations.language,
                        style: TextStyle(
                          color: settings.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      trailing: DropdownButton<Locale>(
                        value: settings.locale,
                        items: supportedLanguages.entries
                            .map((entry) => DropdownMenuItem<Locale>(
                          value: entry.value,
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              color: settings.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ))
                            .toList(),
                        onChanged: (Locale? newLocale) {
                          if (newLocale != null) {
                            notifier.setLocale(newLocale);
                          }
                        },
                        icon: Icon(Icons.arrow_drop_down,
                            color: settings.isDarkMode ? Colors.white : Colors.blue),
                        style: TextStyle(
                          color: settings.isDarkMode ? Colors.white : Colors.black,
                        ),
                        dropdownColor: settings.isDarkMode ? Colors.grey[800] : Colors.white,
                        underline: Container(
                          height: 2,
                          color: Colors.blue, // Blue underline in both modes
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
    );
  }
}