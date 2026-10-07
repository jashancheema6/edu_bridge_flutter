import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../providers/auth_provider.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final loggedUser = authProvider.currentUser;

    if (loggedUser == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    final isStudent = loggedUser.role.toLowerCase() == "student";
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.indigo,
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users") // 🔥 your Firestore user collection
            .doc(loggedUser.id)  // 🔥 use UserModel.id (not uid)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null) {
            return const Center(child: Text("Data not found"));
          }

          // 🔄 Update provider with latest Firestore data
          WidgetsBinding.instance.addPostFrameCallback((_) {
            authProvider.updateLocalUser(data);
          });

          final user = authProvider.currentUser!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // ---------------------------
                // PROFILE IMAGE
                // ---------------------------
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.indigo, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: const Offset(2, 2),
                      )
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: user.profileImage.startsWith("http")
                        ? NetworkImage(user.profileImage)
                        : AssetImage(user.profileImage) as ImageProvider,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                Text(
                  user.role.toUpperCase(),
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),

                const SizedBox(height: 30),

                // ---------------------------
                // INFO CARDS
                // ---------------------------
                _infoCard(
                  title: "Email",
                  value: user.email,
                  icon: Icons.email,
                  color: Colors.blue.shade50,
                ),

                _infoCard(
                  title: isStudent ? "Roll No / UID" : "Teacher ID",
                  value: user.name,
                  icon: Icons.badge,
                  color: Colors.orange.shade50,
                ),

                if (isStudent)
                  _infoCard(
                    title: "Class",
                    value: user.className,
                    icon: Icons.school,
                    color: Colors.green.shade50,
                    editable: true,
                    context: context,
                  ),

                if (!isStudent)
                  _infoCard(
                    title: "Subject",
                    value: user.subject,
                    icon: Icons.book,
                    color: Colors.purple.shade50,
                    editable: true,
                    context: context,
                  ),

                const SizedBox(height: 40),

                // ---------------------------
                // LOGOUT BUTTON
                // ---------------------------
                SizedBox(
                  width: width * 0.5,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      authProvider.logout();
                      Navigator.pushReplacementNamed(context, "/login");
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Logout",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // -------------------------------
  // REUSABLE INFO CARD
  // -------------------------------
  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool editable = false,
    BuildContext? context,
  }) {
    return Card(
      color: color,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value.isNotEmpty ? value : "Not provided",
          style: const TextStyle(fontSize: 15),
        ),
        trailing: editable
            ? IconButton(
          icon: const Icon(Icons.edit, color: Colors.indigo),
          onPressed: () {
            final user = context!.read<AuthProvider>().currentUser!;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditProfilePage(user: user),
              ),
            );
          },
        )
            : null,
      ),
    );
  }
}
