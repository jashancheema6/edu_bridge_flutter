import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custome_button.dart';

class StudentSignupScreen extends StatefulWidget {
  const StudentSignupScreen({super.key});

  @override
  State<StudentSignupScreen> createState() => _StudentSignupScreenState();
}

class _StudentSignupScreenState extends State<StudentSignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  // SIGNUP FUNCTION
  void _signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final className = classController.text.trim();

    if (name.isEmpty || className.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    setState(() => _isLoading = true);

    /// Call AuthProvider Signup
    final String? result = await Provider.of<AuthProvider>(context, listen: false)
        .signup(
      name: name,
      email: email,
      password: password,
      role: "student",
      className: className,
    );

    setState(() => _isLoading = false);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
      return;
    }

    /// Navigate on successful signup
    Navigator.pushReplacementNamed(context, "/studentHome");
  }

  Widget _inputField(
      TextEditingController controller,
      String label, {
        bool obscure = false,
        IconData? icon,
      }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: Colors.indigo) : null,
        filled: true,
        fillColor: Colors.indigo.shade50,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB3C2F2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.indigo),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double maxWidth = 500;

    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxWidth),
            child: Card(
              elevation: 10,
              shadowColor: Colors.indigo.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 28),
                child: Column(
                  children: [
                    const Icon(Icons.school, size: 80, color: Colors.indigo),
                    const SizedBox(height: 15),

                    const Text(
                      "Student Sign Up",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 25),

                    _inputField(nameController, "Full Name", icon: Icons.person),
                    const SizedBox(height: 18),

                    _inputField(classController, "Class", icon: Icons.school),
                    const SizedBox(height: 18),

                    _inputField(emailController, "Email", icon: Icons.email),
                    const SizedBox(height: 18),

                    _inputField(
                      passwordController,
                      "Password",
                      icon: Icons.lock,
                      obscure: true,
                    ),
                    const SizedBox(height: 30),

                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.indigo)
                        : CustomButton(
                      text: "Sign Up",
                      height: 60,
                      icon: Icons.person_add_alt,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF3949AB),
                          Color(0xFF303F9F),
                        ],
                      ),
                      onTap: _signup,
                    ),

                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "/login");
                      },
                      child: Text(
                        "Already have an account? Login",
                        style: TextStyle(
                          color: Colors.indigo.shade700,
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
