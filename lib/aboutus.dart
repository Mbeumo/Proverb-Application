import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Proverbus'),
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
              const Text(
                'About the App',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Proverbus is an application designed to help users explore biblical proverbs, '
                    'take notes, and track their spiritual journey. It provides daily proverbs, '
                    'achievements, and customizable settings to enhance your experience.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Key Features:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildFeatureItem(Icons.today, 'Daily proverbs for motivation'),
              _buildFeatureItem(Icons.emoji_events, 'Track your achievements'),
              _buildFeatureItem(Icons.notifications, 'Daily notifications for new proverbs'),
              _buildFeatureItem(Icons.book, 'Explore various proverbs by chapters'),
              _buildFeatureItem(Icons.note, 'Take and organize notes easily'),
              _buildFeatureItem(Icons.settings, 'Customize settings: themes, notifications, language'),
              const SizedBox(height: 20),
              const Text(
                'Contact & Support',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildContactItem(Icons.email, 'Email', 'support@proverbus.com'),
              _buildContactItem(Icons.web, 'Website', 'www.proverbus.com'),
              _buildContactItem(Icons.phone, 'Phone', '+123 456 7890'),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  '© 2025 Proverbus. All rights reserved.',
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
