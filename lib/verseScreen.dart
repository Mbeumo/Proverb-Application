import 'package:flutter/material.dart';
import 'package:proverbapp/services/databaseservice.dart';

import 'Models/versemodel.dart';
class VerseListScreen extends StatefulWidget {
  final String chapterId;

  const VerseListScreen({super.key, required this.chapterId,});

  @override
  _VerseListScreenState createState() => _VerseListScreenState();
}

class _VerseListScreenState extends State<VerseListScreen> {
  final FirestoreService __database = FirestoreService();
  List<String> verses = [];

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chapterId)),
      body: StreamBuilder<List<Verse>>(
        stream: __database.getVersesForChapter(widget.chapterId), // Call your stream function here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading indicator
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}")); // Show error message
          }

          // Extract the list of chapters
          List<Verse> verses = snapshot.data!;

          return ListView.builder(
            itemCount: verses.length,
            itemBuilder: (context, index) {
              Verse verse = verses[index];

              return ListTile(
                subtitle: Text(verse.id),
                title: Text(verse.content), // Display chapter title
              );
            },
          );
        },
      ),
    );
  }
}
