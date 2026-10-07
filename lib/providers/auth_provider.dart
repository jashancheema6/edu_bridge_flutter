import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? get currentUser => _currentUser;

  // ----------------------------------
  // LOAD CURRENT USER ON APP START
  // ----------------------------------
  Future<void> loadCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      final doc = await _firestore.collection("users").doc(firebaseUser.uid).get();

      if (doc.exists) {
        _currentUser = UserModel.fromMap(doc.data()!);
        notifyListeners();
      }
    }
  }

  // ----------------------------------
  // SIGNUP
  // ----------------------------------
  Future<String?> signup({
    required String name,
    required String email,
    required String password,
    required String role,
    String className = "",
    String subject = "",
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      final userModel = UserModel(
        id: uid,
        name: name,
        email: email,
        role: role,
        className: role == "student" ? className : "",
        subject: role == "teacher" ? subject : "",
        profileImage: "assets/images/default_user.png",
      );

      await _firestore.collection("users").doc(uid).set(userModel.toMap());

      _currentUser = userModel;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // ----------------------------------
  // LOGIN
  // ----------------------------------
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;
      final doc = await _firestore.collection("users").doc(uid).get();

      if (!doc.exists) return "User data not found";

      _currentUser = UserModel.fromMap(doc.data()!);
      notifyListeners();

      return _currentUser!.role; // return role for navigation
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // ----------------------------------
  // LOGOUT
  // ----------------------------------
  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // ----------------------------------
  // UPDATE USER (PROFILE)
  // ----------------------------------
  Future<void> updateUser({
    String? name,
    String? email,
    String? className,
    String? subject,
    String? profileImage,
  }) async {
    if (_currentUser == null) return;

    final uid = _currentUser!.id;

    final updateData = {
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (className != null) "className": className,
      if (subject != null) "subject": subject,
      if (profileImage != null) "profileImage": profileImage,
    };

    await _firestore.collection("users").doc(uid).update(updateData);
  }

  // ----------------------------------
  // SYNC FIRESTORE → PROVIDER
  // ----------------------------------
  void updateLocalUser(Map<String, dynamic> data) {
    _currentUser = UserModel.fromMap(data);
    notifyListeners();
  }
}
