import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proverbapp/Models/notemodel.dart';
import '../Models/chaptermodel.dart';
import '../Models/versemodel.dart';
import '../Models/achievement.dart';


class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Chapters
  Future<void> addChapter(context,Chapter chapter) async {
    await _firestore.collection('chapters').doc(chapter.id).set(chapter.toMap());
        //.delete();
        //.set(chapter.toMap());

  }

  Stream<List<Chapter>> getChapters() {
    return _firestore.collection('chapters')
        .snapshots()
        .map((snapshot) {
        List<Chapter> chapters = snapshot.docs.map((doc) => Chapter.fromFirestore(doc)).toList();
        // Sorting by extracting the numeric part from IDs like "proverbs_1"
        chapters.sort((a, b) {
          final aNum = _extractNumber(a.id);
          final bNum = _extractNumber(b.id);
          return aNum.compareTo(bNum);
        });

        return chapters;
    });
  }
  Stream<List<Chapter>> getChaptersspec(String id) {
    return _firestore.collection('chapters')
        .where('id', isEqualTo: id)
        .snapshots()
        .map((snapshot) {
      List<Chapter> chapters = snapshot.docs.map((doc) => Chapter.fromFirestore(doc)).toList();
      // Sorting by extracting the numeric part from IDs like "proverbs_1"

      return chapters;
    });
  }
  int _extractNumber(String id) {
    final match = RegExp(r'_(\d+)$').firstMatch(id);  // Extract digits after "_"
    return match != null ? int.parse(match.group(1)!) : 0;  // Convert to integer
  }

  // Verses
  Future<void> addVerse(context,Verse verse) async {
    /*Verse verse =Verse(
      id: 'proverbs_1_1',
      chapterId: 'proverbs_1',
      content: 'The proverbs of Solʹo·mon, the son of David, the king of Israel:',
    );*/
    await _firestore.collection('verses').doc(verse.id).set(verse.toMap());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('added Chap 2 succesfully')),
    );
  }

  Stream<List<Verse>> getVersesForChapter(String chapterId) {
    return _firestore
        .collection('verses')
        .where('chapterId', isEqualTo: chapterId)
        .snapshots()
        .map((snapshot) {
        List<Verse> verses=snapshot.docs.map((doc) => Verse.fromFirestore(doc)).toList();
          verses.sort((a, b) {
            final aNum = _extractNumber(a.id);
            final bNum = _extractNumber(b.id);
            return aNum.compareTo(bNum);
          });

      return verses;
    });

  }

  Future<String> getDailyVerse() async {
    try {
      DocumentReference docRef = _firestore.collection('daily_verse').doc('today');
      DocumentSnapshot doc = await docRef.get();

      String todayDate = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD format

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['date'] == todayDate) {
          //print("Using existing daily verse: ${data['verse']}");
          return data['verse']; // Return today's verse
        }
      }

      // If no verse for today, pick a new one
      String newVerse = await getVerseRand();

      // Update Firestore
      await docRef.set({
        'verse': newVerse,
        'date': todayDate,
      });

      //print("New daily verse set: $newVerse");
      return newVerse;
    } catch (e) {
      //print("Error fetching daily verse: $e");
      return "Verse unavailable";
    }
  }
  Future<String> getVerseRand() async{
    List<String> allVerses = await getAllVerses();
    if (allVerses.isEmpty) {
      return "No verses found.";
    }

    Random random = Random();
    int randomIndex = random.nextInt(allVerses.length);

    return allVerses[randomIndex];
  }

  Future<List<String>> getAllVerses() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('verses').get();
      return snapshot.docs.map((doc) => doc['content'] as String).toList();//must return all the erse attributes
    //get all the verse attribute or just the verse contant it depned on me as from here
    } catch (e) {
      print("Error getting verses: $e");
      return [];
    }
  }

  // Notes
  Future<void> addNote(Note note) async {
    await _firestore.collection('notes').doc(note.id).set(note.toMap());
  }

  Stream<List<Note>> getNotesForUserVerse(String userId, String verseId) {
    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .where('verseId', isEqualTo: verseId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList());
  }

  // Achievements
  Future<void> updateAchievements(Achievement achievement) async {
    await _firestore
        .collection('achievements')
        .doc(achievement.userId)
        .set(achievement.toMap(), SetOptions(merge: true));
  }

  Stream<Achievement> getAchievements(String userId) {
    return _firestore
        .collection('achievements')
        .doc(userId)
        .snapshots()
        .map((doc) => Achievement.fromFirestore(doc));
  }
}