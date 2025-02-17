import 'package:firebase_auth/firebase_auth.dart';
import 'databaseservice.dart';

class AchievementService {
  final FirestoreService _firestoreService;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AchievementService(this._firestoreService);

  Future<void> trackChapterCompletion(String chapterId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final achievementDoc = await _firestoreService.getAchievements(user.uid).first;
    final achievement = achievementDoc ;

    if (!achievement.completedChapters.contains(chapterId)) {
      achievement.completedChapters.add(chapterId);
      await _firestoreService.updateAchievements(achievement);
    }
  }

  Future<void> trackVerseCompletion(String verseId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final achievementDoc = await _firestoreService.getAchievements(user.uid).first;
    final achievement = achievementDoc;

    if (!achievement.completedVerses.contains(verseId)) {
      achievement.completedVerses.add(verseId);
      await _firestoreService.updateAchievements(achievement);
    }
  }
}