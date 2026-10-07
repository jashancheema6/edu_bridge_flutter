import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custome_button.dart';

class TeacherSignupScreen extends StatefulWidget {
  const TeacherSignupScreen({super.key});

  @override
  State<TeacherSignupScreen> createState() => _TeacherSignupScreenState();
}

class _TeacherSignupScreenState extends State<TeacherSignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final subjectController = TextEditingController();

  bool _isLoading = false;

  void _signup() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String subject = subjectController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || subject.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all required fields")));
      return;
    }

    setState(() => _isLoading = true);

    String? result = await Provider.of<AuthProvider>(context, listen: false).signup(
      name: name,
      email: email,
      password: password,
      role: "teacher",
      subject: subject,
    );

    setState(() => _isLoading = false);

    if (result != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
      return;
    }

    // Navigate to teacher dashboard
    Navigator.pushReplacementNamed(context, "/teacherHome");
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscure = false, IconData? icon}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: Colors.indigo) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.indigo.shade50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: const Text("Teacher Sign Up"),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 8,
              shadowColor: Colors.indigo.withOpacity(0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person, size: 80, color: Colors.indigo),
                    const SizedBox(height: 10),
                    const Text(
                      "Teacher Sign Up",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    _buildTextField(nameController, "Full Name", icon: Icons.person),
                    const SizedBox(height: 15),
                    _buildTextField(emailController, "Email", icon: Icons.email),
                    const SizedBox(height: 15),
                    _buildTextField(subjectController, "Subject", icon: Icons.book),
                    const SizedBox(height: 15),
                    _buildTextField(passwordController, "Password", icon: Icons.lock, obscure: true),
                    const SizedBox(height: 30),
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.indigo)
                        : CustomButton(
                      text: "Sign Up",
                      height: 55,
                      gradient: const LinearGradient(
                        colors: [Colors.indigo, Colors.indigo],
                      ),
                      onTap: _signup,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, "/login"),
                      child: Text(
                        "Already have an account? Login",
                        style: TextStyle(
                          color: Colors.indigo.shade700,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
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
