import 'package:cloud_firestore/cloud_firestore.dart';

class Achievement {
  final int id;
  final String userId;
  final List<String> completedChapters;
  final List<String> completedVerses;
  final int achievementnumber;
  final DateTime lastUpdated;

  Achievement({
    required this.id,
    required this.userId,
    required this.completedChapters,
    required this.completedVerses,
    this.achievementnumber = 0,
    required this.lastUpdated,
  });
  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'userId':userId,// from firebase authenticated user
      'completedChapters': completedChapters,
      'completedVerses': completedVerses,
      'achievementnumber' : achievementnumber,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  factory Achievement.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Achievement(
      id: data['id'],
      userId: doc.id,
      completedChapters: List<String>.from(data['completedChapters']),
      completedVerses: List<String>.from(data['completedVerses']),
      achievementnumber: data['achievementnumber'],
      lastUpdated: data['lastUpdated'].toDate(),
    );
  }
}