// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up user with email & password
  Future<User?> signUp(String email, String password) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  // Login user with email & password
  Future<User?> login(String email, String password) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get current logged-in Firebase user
  User? get currentUser => _auth.currentUser;
}
