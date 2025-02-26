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
    final verses = await _database
        .getVersesForChapter(chapterId)
        .first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Proverbus')),
      body: CustomScrollView(
        slivers: [
          /// **Collapsing Header**
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false, // Removes the back arrow
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(bottom: 16, left: 16),
              centerTitle: false,
              title: Text(
                "Book of Proverbs 📖",
                style: TextStyle(fontSize: 16), // Smaller font on collapse
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B5E3C), Color(0xFF5E3B1F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20)),
                ),
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Wisdom for a meaningful life",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// **List of Chapters (Now using SliverList)**
          StreamBuilder<List<Chapter>>(
            stream: _database.getChapters(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(child: Text("Error: ${snapshot.error}")),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(child: Text("No chapters available")),
                );
              }

              List<Chapter> chapters = snapshot.data!;

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    Chapter chapter = chapters[index];
                    return FutureBuilder<List<Verse>>(
                      future: _database
                          .getVersesForChapter(chapter.id)
                          .first,
                      builder: (context, snapshot) {
                        bool hasVerses = snapshot.hasData && snapshot.data!
                            .isNotEmpty;
                        return _buildChapTile(context, chapter, hasVerses);
                      },
                    );
                  },
                  childCount: chapters
                      .length, // Corrected to match chapters count
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /*Widget _buildHeader() {
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
          Text(
            "Book of Proverbs 📖",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
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
  }*/
  Widget _buildChapTile(BuildContext context, Chapter chap, bool hasVerses) {
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(
            chap.id,
            style: TextStyle(
              color: hasVerses ? Colors.black : Colors.grey,
              // Grey out if no verses
              fontWeight: hasVerses
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          onTap: hasVerses
              ? () {
            Navigator.pushNamed(
              context,
              '/verseInChap',
              arguments: chap.id,
            );
          }
              : () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('This chapter has no verses!')),
            );
          }, // Disable tap if no verses
          tileColor: hasVerses ? Colors.white : Colors
              .grey[300], // Grey background if no verses
        )
    );
  }
}

