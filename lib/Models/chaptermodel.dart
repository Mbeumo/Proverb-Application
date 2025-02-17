import 'package:cloud_firestore/cloud_firestore.dart';

class Chapter {
  final String id;
  final String description;
  final bool reading;
  final bool completed;

  Chapter({
    required this.id,
    required this.description,
    this.reading = false,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'reading': reading,
      'completed': completed,
    };
  }

  factory Chapter.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Chapter(
      id: doc.id,
      description: data['description'],
      reading: data['reading'] ?? false,
      completed: data['completed'] ?? false,
    );
  }
}
