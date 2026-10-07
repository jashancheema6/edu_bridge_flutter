import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController classOrSubjectController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    classOrSubjectController = TextEditingController(
        text: widget.user.role.toLowerCase() == "student"
            ? widget.user.className
            : widget.user.subject);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    classOrSubjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final isStudent = widget.user.role.toLowerCase() == "student";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: classOrSubjectController,
              decoration: InputDecoration(
                  labelText: isStudent ? "Class" : "Subject"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                authProvider.updateUser(
                  name: nameController.text,
                  email: emailController.text,
                  className:
                  isStudent ? classOrSubjectController.text : null,
                  subject: isStudent ? null : classOrSubjectController.text,
                );
                Navigator.pop(context);
              },
              child: const Text("Save Changes"),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.indigo,
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
