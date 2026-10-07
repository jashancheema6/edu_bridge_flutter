import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../providers/auth_provider.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final String uid = user.id;

    // Dashboard menu items
    final List<_DashboardItem> items = [
      _DashboardItem("View Notes", Icons.note, Colors.lightBlue.shade100, "/pdf_viewer"),
      _DashboardItem("Download Notes", Icons.download, Colors.orange.shade100, "/downloadNotes"),
      _DashboardItem("Assignments", Icons.assignment, Colors.green.shade100, "/viewAssignment"),
      _DashboardItem("Announcements", Icons.notifications, Colors.purple.shade100, "/notice"),
      _DashboardItem("Profile", Icons.person, Colors.red.shade100, "/profile"),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacementNamed(context, "/login");
            },
          )
        ],
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final name = data["name"] ?? "Student";
          final className = data["className"] ?? "Class";   // <-- FIXED FIELD NAME
          final profileImage = data["profileImage"] ?? "";

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: profileImage.isNotEmpty
                          ? NetworkImage(profileImage)
                          : const AssetImage("assets/images/default_user.png")
                      as ImageProvider,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome, $name!",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        Text(
                          "Class: $className",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: GridView.builder(
                    itemCount: items.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return InkWell(
                        onTap: () => Navigator.pushNamed(context, item.route),
                        child: Container(
                          decoration: BoxDecoration(
                            color: item.color,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(item.icon, size: 32, color: Colors.indigo),
                              const SizedBox(height: 8),
                              Text(
                                item.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  _DashboardItem(this.title, this.icon, this.color, this.route);
}
