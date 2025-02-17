import 'package:flutter/material.dart';
import 'package:proverbapp/Models/versemodel.dart';
import 'package:proverbapp/services/databaseservice.dart';
import 'package:proverbapp/Models/chaptermodel.dart';
class ChapterListScreen extends StatefulWidget {
  const ChapterListScreen({super.key});

  @override
  _ChapterListScreenState createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  List<Map<String, dynamic>> chapters = [];
  final FirestoreService _database = FirestoreService();
  @override
  void initState() {
    super.initState();
  }

  Future<void> _onChapterTap(String chapterId) async {
    // Await the asynchronous function to get verses.
    final verses = await _database.getVersesForChapter(chapterId).first;

    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chapters")),
      body: StreamBuilder<List<Chapter>>(
        stream: _database.getChapters(), // Call your stream function here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading indicator
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}")); // Show error message
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No chapters available")); // Handle empty data
          }

          // Extract the list of chapters
          List<Chapter> chapters = snapshot.data!;

          return ListView.builder(
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              Chapter chapter = chapters[index];

              return FutureBuilder<List<Verse>>(
                future: _database.getVersesForChapter(chapter.id).first, // Fetch verses
                builder: (context, snapshot) {
                  bool hasVerses = snapshot.hasData && snapshot.data!.isNotEmpty;

                  return ListTile(
                    title: Text(
                      chapter.id,
                      style: TextStyle(
                        color: hasVerses ? Colors.black : Colors.grey, // Grey out if no verses
                        fontWeight: hasVerses ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    onTap: hasVerses
                        ? () {
                      Navigator.pushNamed(
                        context,
                        '/verseInChap',
                        arguments: chapter.id,
                      );
                    }
                        : null, // Disable tap if no verses
                    tileColor: hasVerses ? Colors.white : Colors.grey[300], // Grey background if no verses
                  );
                },
              );

            },
          );
        },
      ),
    );
  }
}
