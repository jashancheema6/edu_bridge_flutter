import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class MessageProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<MessageModel> _messages = [];
  List<MessageModel> get messages => List.unmodifiable(_messages);

  /// Listen to messages between two users in real-time
  Stream<List<MessageModel>> streamMessages(String userId, String peerId) {
    return _firestore
        .collection("messages")
        .where("participants", arrayContains: userId)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) {
      final filtered = snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data()))
          .where((msg) =>
      (msg.senderId == userId && msg.receiverId == peerId) ||
          (msg.senderId == peerId && msg.receiverId == userId))
          .toList();

      _messages = filtered;
      notifyListeners();
      return filtered;
    });
  }

  /// Send a message
  Future<void> sendMessage({
    required String content,
    required String senderId,
    required String receiverId,
  }) async {
    final messageId = _firestore.collection("messages").doc().id;

    final message = MessageModel(
      id: messageId,
      content: content,
      senderId: senderId,
      receiverId: receiverId,
      timestamp: DateTime.now(),
    );

    try {
      await _firestore.collection("messages").doc(messageId).set({
        "id": message.id,
        "content": message.content,
        "senderId": message.senderId,
        "receiverId": message.receiverId,
        "timestamp": Timestamp.fromDate(message.timestamp),
        "participants": [senderId, receiverId],
      });
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

  /// Delete a message by ID
  Future<void> deleteMessage(String messageId) async {
    try {
      await _firestore.collection("messages").doc(messageId).delete();
    } catch (e) {
      debugPrint("Error deleting message: $e");
    }
  }
}
