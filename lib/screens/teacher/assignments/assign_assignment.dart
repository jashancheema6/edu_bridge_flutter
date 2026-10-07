import 'package:flutter/material.dart';
import '../../../widgets/custome_button.dart';

class AssignAssignment extends StatelessWidget {
  const AssignAssignment({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController assignmentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Assignment"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Assignment title input
            TextField(
              controller: assignmentController,
              decoration: const InputDecoration(
                labelText: "Assignment Title",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.assignment, color: Colors.indigo),
                labelStyle: TextStyle(color: Colors.indigo),
              ),
            ),
            const SizedBox(height: 20),

            // Choose File Button (light color + icon + indigo text)
            CustomButton(
              text: "Choose File",
              icon: Icons.attach_file,
              fontSize: 16,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFF3E0),
                  Color(0xFFFFE0B2)
                ], // light orange
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("File picker not implemented")),
                );
              },
            ),
            const SizedBox(height: 20),

            // Assign Button (light color + icon + indigo text)
            CustomButton(
              text: "Assign",
              icon: Icons.send,
              fontSize: 16,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFE0F7FA),
                  Color(0xFFB2EBF2)
                ], // light cyan
              ),
              onTap: () {
                String title = assignmentController.text.trim();
                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter assignment title")),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$title assigned successfully!")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
