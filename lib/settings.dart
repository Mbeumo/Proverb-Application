import 'package:flutter/material.dart';
import 'package:proverbapp/services/translation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  final Function(bool) onDarkModeChanged;
  final Function(String) onLanguageChanged;
  SettingsView({required this.onDarkModeChanged,required this.onLanguageChanged});

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString('language') ?? 'en';
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _selectedLanguage = prefs.getString('language') ?? 'en'; // Load language code
    });
  }

  Future<void> _updateDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() {
      _isDarkMode = value;
    });
    widget.onDarkModeChanged(value); // Notify MyApp about the change
  }

  Future<void> _updateNotifications(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  Future<void> _updateLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    setState(() {
      _selectedLanguage = languageCode; // Update language code
    });
    widget.onLanguageChanged(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('settings')!),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.translate('dark_mode')!),
            value: _isDarkMode,
            onChanged: _updateDarkMode,
          ),
          SwitchListTile(
            title:Text(AppLocalizations.of(context)!.translate('enable_notifications')!),
            value: _notificationsEnabled,
            onChanged: _updateNotifications,
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.translate('language')!),
            subtitle: Text(_selectedLanguage),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _updateLanguage(newValue);
                }
              },
              items: [{'code': 'en', 'name': 'English'},
                {'code': 'fr', 'name': 'French'},
                {'code': 'es', 'name': 'Spanish'},]
                  .map<DropdownMenuItem<String>>((Map<String, String> item) {
                return DropdownMenuItem<String>(
                  value: item['code']!,
                  child: Text(item['name']!,
                  style:Theme.of(context).textTheme.labelSmall,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
