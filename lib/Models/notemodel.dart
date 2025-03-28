import 'package:cloud_firestore/cloud_firestore.dart';
class Note {
  final String id;
  final String userId;
  final String verseId;
  final String noteContent;
  final String chapId;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.userId,
    this.verseId ="No verse",
    required this.chapId,
    required this.noteContent,
    required this.createdAt,

  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'verseId': verseId,
      'chapId':chapId,
      'noteContent': noteContent,
      'createdAt':Timestamp.fromDate(createdAt),
    };
  }

  factory Note.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;

    return Note(
      id: doc.id,
      userId: data['userId'],
      verseId: data['verseId'],
      chapId: data['chapId'],
      noteContent: data['noteContent'],
      createdAt: data['createdAt'].toDate(),
    );
  }
}
