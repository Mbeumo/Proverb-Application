import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proverbapp/Models/chaptermodel.dart';
import 'package:proverbapp/services/databaseservice.dart';
import 'package:proverbapp/Models/notemodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/translation.dart';

class AddNotePage extends StatefulWidget {
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _noteController = TextEditingController();
  final FirestoreService _db = FirestoreService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  String? _selectedChapter;
int i=0;
  Future<void> _saveNote() async {
    String noteText = _noteController.text.trim();
    if (noteText.isNotEmpty) {
      i++;
      Note newNote = Note(
        id: i.toString(),
        userId: userId,
        chapId: _selectedChapter!,
        noteContent: noteText,
        createdAt: DateTime.now(),
      );
      await _db.addNote(newNote);
      Navigator.pop(context); // Close the page after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.translate('add_note')!)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // StreamBuilder for fetching chapters
            StreamBuilder<List<Chapter>>(
              stream: _db.getChapters(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(AppLocalizations.of(context)!.translate('error_fetching_chapter')!);
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text(AppLocalizations.of(context)!.translate('no_chapters_available')!);
                } else {
                  final List<String> chapters = snapshot.data!.map((chapter) => chapter.id).toList();
                  if (_selectedChapter == null && chapters.isNotEmpty) {
                    _selectedChapter =
                    chapters[0]; // Select the first chapter by default
                  }

                  return DropdownButton<String>(
                    value: _selectedChapter,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedChapter = newValue;
                      });
                    },
                    items:  chapters.map<DropdownMenuItem<String>>((String chapter) {
                      return DropdownMenuItem<String>(
                        value: chapter,
                        child: Text(chapter),
                      );
                    }).toList(),
                    hint: Text(AppLocalizations.of(context)!.translate('select_chapter')!),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(hintText: "${AppLocalizations.of(context)!.translate('input_note')!}..."),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text(AppLocalizations.of(context)!.translate('save_note')!),
            ),
          ],
        ),
      ),

    );
  }
}
