import 'package:flutter/material.dart';
import 'package:proverbapp/services/databaseservice.dart';
import '../Models/chaptermodel.dart';
import '../Models/versemodel.dart';
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
      body: Column(
          children: [
            _buildHeader(), // Elegant header
            Expanded(
                child: StreamBuilder<List<Verse>>(
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
            ),
          ]
      )
    );
  }
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8B5E3C), Color(0xFF5E3B1F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<List<Chapter>>(
            stream: __database.getChaptersspec(widget.chapterId), // Call your stream function here
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); // Show loading indicator
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}")); // Show error message
              }

              // Extract the list of chapters
              Chapter chapter = snapshot.data!.firstWhere((chap) => chap.id == widget.chapterId);
              return Text(
                chapter.description,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          SizedBox(height: 5),
          Text(
            "Wisdom for a meaningful life",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
