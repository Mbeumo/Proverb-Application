import 'package:cloud_firestore/cloud_firestore.dart';

class Verse {
  final String id;
  final String chapterId;
  final String content;

  Verse({
    required this.id,
    required this.chapterId,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chapterId': chapterId,
      'content': content,
    };
  }

  factory Verse.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Verse(
      id: doc.id,
      chapterId: data['chapterId'],
      content: data['content'],
    );
  }
}
