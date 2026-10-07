// lib/services/messaging_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---------------------------
  // COLLECTION REFERENCE
  // ---------------------------
  CollectionReference get messagesRef => _firestore.collection('messages');

  // ---------------------------
  // SEND MESSAGE
  // ---------------------------
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
    String type = "text", // can be 'text', 'file', 'image', etc.
  }) async {
    await messagesRef.add({
      "senderId": senderId,
      "receiverId": receiverId,
      "content": content,
      "type": type,
      "createdAt": FieldValue.serverTimestamp(),
      "read": false,
    });
  }

  // ---------------------------
  // GET CONVERSATION BETWEEN TWO USERS
  // ---------------------------
  Stream<QuerySnapshot> getConversation({
    required String user1Id,
    required String user2Id,
  }) {
    return messagesRef
        .where("senderId", whereIn: [user1Id, user2Id])
        .where("receiverId", whereIn: [user1Id, user2Id])
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  // ---------------------------
  // MARK MESSAGE AS READ
  // ---------------------------
  Future<void> markAsRead(String messageId) async {
    await messagesRef.doc(messageId).update({"read": true});
  }

  // ---------------------------
  // DELETE MESSAGE
  // ---------------------------
  Future<void> deleteMessage(String messageId) async {
    await messagesRef.doc(messageId).delete();
  }

  // ---------------------------
  // GET ALL MESSAGES FOR A USER
  // ---------------------------
  Stream<QuerySnapshot> getMessagesForUser(String userId) {
    return messagesRef
        .where("receiverId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
}
