import 'package:flutter/material.dart';
import '../../widgets/custome_button.dart';
import 'student_signup_screen.dart';
import 'teacher_signup_screen.dart';

class SignupOptionsScreen extends StatelessWidget {
  const SignupOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Increase max width of card
    final double maxCardWidth = 500;

    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxCardWidth),
            child: Card(
              elevation: 8,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_add_alt_1, size: 80, color: Colors.indigo),
                    const SizedBox(height: 20),
                    const Text(
                      "Choose Your Role",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // ---------------- STUDENT BUTTON ----------------
                    CustomButton(
                      text: "Sign up as Student",
                      icon: Icons.school,
                      height: 60,
                      width: double.infinity,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)], // Light blue
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StudentSignupScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // ---------------- TEACHER BUTTON ----------------
                    CustomButton(
                      text: "Sign up as Teacher",
                      icon: Icons.person,
                      height: 60,
                      width: double.infinity,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF8BBD0), Color(0xFFF48FB1)], // Light pink
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TeacherSignupScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 40),

                    // Optional login link
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/login");
                      },
                      child: const Text(
                        "Already have an account? Login",
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
