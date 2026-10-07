import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custome_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter all fields")));
      return;
    }

    setState(() => _isLoading = true);

    String? result = await Provider.of<AuthProvider>(context, listen: false)
        .login(email: email, password: password);

    setState(() => _isLoading = false);

    // ---- CORRECT LOGIN HANDLING ----
    if (result == "student") {
      Navigator.pushReplacementNamed(context, "/studentHome");
      return;
    }

    if (result == "teacher") {
      Navigator.pushReplacementNamed(context, "/teacherHome");
      return;
    }

    // If result is any other string => it's an error message
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(result ?? "Login failed")));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.9;

    if (screenWidth > 600) cardWidth = 500;
    if (screenWidth > 1000) cardWidth = 600;

    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: cardWidth,
            child: Card(
              elevation: 10,
              shadowColor: Colors.indigo.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(vertical: 40),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.school, size: 80, color: Colors.indigo),
                    const SizedBox(height: 10),

                    const Text(
                      "EduBridge",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 10),

                    const Text(
                      "Connecting Teachers & Students",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.indigoAccent,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Email Field
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email, color: Colors.indigo),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.indigo),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.indigo.shade100),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Password Field
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock, color: Colors.indigo),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.indigo),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.indigo.shade100),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Login Button
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.indigo)
                        : CustomButton(
                      text: "Login",
                      icon: Icons.login,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)],
                      ),
                      onTap: _login,
                    ),

                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/signup-options");
                      },
                      child: const Text(
                        "Don't have an account? Sign up",
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
