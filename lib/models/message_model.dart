import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;           // message id (Firestore doc id)
  final String senderId;     // teacher or student id
  final String receiverId;   // recipient id
  final String content;      // message text
  final DateTime timestamp;  // message sent time

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp), // store as Firestore Timestamp
    };
  }

  // Create MessageModel from Firestore document
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    final ts = map['timestamp'];
    DateTime time;

    if (ts is Timestamp) {
      time = ts.toDate();
    } else if (ts is DateTime) {
      time = ts;
    } else {
      time = DateTime.now(); // fallback
    }

    return MessageModel(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      content: map['content'] ?? '',
      timestamp: time,
    );
  }
}
