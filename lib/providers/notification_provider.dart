import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _notifications = [];

  List<Map<String, dynamic>> get notifications => _notifications;

  NotificationProvider() {
    // Load notifications from Firestore in real-time
    _firestore
        .collection('notifications')
        .orderBy('time', descending: true)
        .snapshots()
        .listen((snapshot) {
      _notifications = snapshot.docs.map((doc) {
        final data = doc.data();

        // Safely handle Timestamp
        DateTime? time;
        if (data['time'] != null && data['time'] is Timestamp) {
          time = (data['time'] as Timestamp).toDate();
        }

        return {
          "id": doc.id,
          "title": data['title'] ?? "",
          "message": data['message'] ?? "",
          "type": data['type'] ?? "",
          "time": time, // store as DateTime
        };
      }).toList();
      notifyListeners();
    });
  }

  /// Add notification to Firestore
  Future<void> addNotification({
    required String title,
    required String message,
    required String type,
  }) async {
    await _firestore.collection('notifications').add({
      "title": title,
      "message": message,
      "type": type,
      "time": FieldValue.serverTimestamp(),
    });
  }

  /// Remove notification by document ID
  Future<void> removeNotification(String id) async {
    await _firestore.collection('notifications').doc(id).delete();
  }

  /// Clear all notifications (careful with this!)
  Future<void> clearAll() async {
    final snapshot = await _firestore.collection('notifications').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
