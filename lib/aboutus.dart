import 'package:flutter/material.dart';
import 'package:proverbapp/services/translation.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('about')!,),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:SingleChildScrollView(
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Icon(Icons.book, size: 80, color: Colors.blue),
                    const SizedBox(height: 10),
                    Text(
                      'Proverbus',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Version 1.0.0',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                  AppLocalizations.of(context)!.translate('about_the_app')!,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                  AppLocalizations.of(context)!.translate('app_description')!,
                  style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.translate('key_features')!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildFeatureItem(Icons.today,AppLocalizations.of(context)!.translate('daily_proverbs_for_motivation')!,),
              _buildFeatureItem(Icons.emoji_events,AppLocalizations.of(context)!.translate('track_your_achievements')!,),
              _buildFeatureItem(Icons.notifications,AppLocalizations.of(context)!.translate('daily_notifications_for_new_proverbs')!,),
              _buildFeatureItem(Icons.book, AppLocalizations.of(context)!.translate('explore_various_proverbs_by_chapters')!,),
              _buildFeatureItem(Icons.note, AppLocalizations.of(context)!.translate('take_and_organize_notes_easily')!,),
              _buildFeatureItem(Icons.settings, AppLocalizations.of(context)!.translate('customize_settings')!,),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.translate('contact_support')!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildContactItem(Icons.email, AppLocalizations.of(context)!.translate('email')!, 'mbeumobriand@gmail.com'),
              _buildContactItem(Icons.web, AppLocalizations.of(context)!.translate('website')!, 'www.proverbus.com'),
              _buildContactItem(Icons.phone,AppLocalizations.of(context)!.translate('phone')!, '+237 682740678'),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  '© 2025 Proverbus. ${AppLocalizations.of(context)!.translate('all_rights_reserved')!}.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        )

      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
