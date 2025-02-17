import 'dart:io';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage({
    Uint8List? bytes,
    File? file,
    required String destinationPath,
  }) async {
    final storageRef = _storage.ref().child(destinationPath);
    UploadTask uploadTask;

    if (kIsWeb && bytes != null) {
      // For web, upload the raw bytes.
      uploadTask = storageRef.putData(bytes);
    } else if (!kIsWeb && file != null) {
      // For mobile, upload the file.
      uploadTask = storageRef.putFile(file);
    } else {
      throw Exception('No valid file data provided');
    }

    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    return await snapshot.ref.getDownloadURL();
  }

}

