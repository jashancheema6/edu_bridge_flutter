// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---------------------------
  // USERS COLLECTION
  // ---------------------------
  CollectionReference get usersRef => _firestore.collection('users');

  Future<DocumentSnapshot> getUserById(String uid) async {
    return await usersRef.doc(uid).get();
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await usersRef.doc(uid).update(data);
  }

  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    await usersRef.doc(uid).set(data);
  }

  // ---------------------------
  // ASSIGNMENTS COLLECTION
  // ---------------------------
  CollectionReference get assignmentsRef => _firestore.collection('assignments');

  Future<DocumentSnapshot> getAssignmentById(String id) async {
    return await assignmentsRef.doc(id).get();
  }

  Future<void> createAssignment(Map<String, dynamic> data) async {
    await assignmentsRef.add(data);
  }

  Future<void> updateAssignment(String id, Map<String, dynamic> data) async {
    await assignmentsRef.doc(id).update(data);
  }

  Future<void> deleteAssignment(String id) async {
    await assignmentsRef.doc(id).delete();
  }

  Stream<QuerySnapshot> getAllAssignments() {
    return assignmentsRef.orderBy('createdAt', descending: true).snapshots();
  }

  // ---------------------------
  // NOTES COLLECTION
  // ---------------------------
  CollectionReference get notesRef => _firestore.collection('notes');

  Future<void> uploadNote(Map<String, dynamic> data) async {
    await notesRef.add(data);
  }

  Stream<QuerySnapshot> getAllNotes() {
    return notesRef.orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> deleteNote(String id) async {
    await notesRef.doc(id).delete();
  }

  // ---------------------------
  // NOTIFICATIONS COLLECTION
  // ---------------------------
  CollectionReference get notificationsRef =>
      _firestore.collection('notifications');

  Future<void> addNotification(Map<String, dynamic> data) async {
    await notificationsRef.add({
      ...data,
      "time": FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getAllNotifications() {
    return notificationsRef.orderBy('time', descending: true).snapshots();
  }

  Future<void> removeNotification(String id) async {
    await notificationsRef.doc(id).delete();
  }

  Future<void> clearAllNotifications() async {
    final snapshot = await notificationsRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
