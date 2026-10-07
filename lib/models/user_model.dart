import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;           // Firebase UID
  final String name;
  final String email;
  final String role;         // student / teacher
  final String className;    // only for students
  final String subject;      // only for teachers
  final String profileImage; // Firebase Storage URL or local asset

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.className = "",
    this.subject = "",
    required this.profileImage,
  });

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "role": role,
      "className": className,
      "subject": subject,
      "profileImage": profileImage,
    };
  }

  // Create UserModel from a Map (Firestore document data)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"] ?? "",
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      role: map["role"] ?? "student",
      className: map["className"] ?? "",
      subject: map["subject"] ?? "",
      profileImage: map["profileImage"] ?? "assets/images/default_user.png",
    );
  }

  // Create UserModel from Firestore DocumentSnapshot
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel.fromMap(data);
  }
}
