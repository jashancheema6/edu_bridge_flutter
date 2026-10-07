// lib/services/storage_service.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ---------------------------
  // UPLOAD FILE TO STORAGE
  // ---------------------------
  /// Returns the download URL after successful upload
  Future<String?> uploadFile({
    required File file,
    required String path, // e.g., "assignments/student123/file.pdf"
  }) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = ref.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      print("Storage upload error: ${e.message}");
      return null;
    }
  }

  // ---------------------------
  // DELETE FILE FROM STORAGE
  // ---------------------------
  Future<void> deleteFile(String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.delete();
    } on FirebaseException catch (e) {
      print("Storage delete error: ${e.message}");
    }
  }

  // ---------------------------
  // GET DOWNLOAD URL
  // ---------------------------
  Future<String?> getDownloadUrl(String path) async {
    try {
      final ref = _storage.ref().child(path);
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      print("Get download URL error: ${e.message}");
      return null;
    }
  }
}
