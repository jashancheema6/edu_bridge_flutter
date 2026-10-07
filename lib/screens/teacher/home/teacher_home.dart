import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../providers/theme_provider.dart';

class TeacherHome extends StatelessWidget {
  const TeacherHome({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (width >= 800) crossAxisCount = 4;
    else if (width >= 600) crossAxisCount = 3;

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Dashboard"),
        backgroundColor: Colors.indigo,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings, color: Colors.white, size: 26),
            onSelected: (value) {
              if (value == "light" && themeProvider.isDarkMode) {
                themeProvider.toggleTheme();
              } else if (value == "dark" && !themeProvider.isDarkMode) {
                themeProvider.toggleTheme();
              } else if (value == "logout") {
                Navigator.pushReplacementNamed(context, "/login");
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "light",
                child: Row(
                  children: [
                    Icon(Icons.light_mode, color: Colors.orange),
                    SizedBox(width: 10),
                    Text("Light Theme"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: "dark",
                child: Row(
                  children: [
                    Icon(Icons.dark_mode, color: Colors.black87),
                    SizedBox(width: 10),
                    Text("Dark Theme"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: "logout",
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 10),
                    Text("Logout"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text(
              "Welcome Teacher!",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder(
                stream: firestore.collection('notes').snapshots(),
                builder: (context, noteSnapshot) {
                  return StreamBuilder(
                    stream: firestore.collection('assignments').snapshots(),
                    builder: (context, assignmentSnapshot) {
                      return StreamBuilder(
                        stream: firestore
                            .collection('messages')
                            .where('role', isEqualTo: 'student')
                            .snapshots(),
                        builder: (context, messageSnapshot) {
                          // Counts for dashboard
                          int notesCount = 0;
                          int assignmentsCount = 0;
                          int messagesCount = 0;

                          if (noteSnapshot.hasData) {
                            notesCount = noteSnapshot.data!.docs.length;
                          }
                          if (assignmentSnapshot.hasData) {
                            assignmentsCount =
                                assignmentSnapshot.data!.docs.length;
                          }
                          if (messageSnapshot.hasData) {
                            messagesCount = messageSnapshot.data!.docs.length;
                          }

                          final List<_DashboardItem> items = [
                            _DashboardItem(
                                title: "Upload Notes\n($notesCount)",
                                icon: Icons.note_add,
                                color: Colors.lightBlue.shade100,
                                route: "/uploadNotes"),
                            _DashboardItem(
                                title: "Assign Assignment\n($assignmentsCount)",
                                icon: Icons.assignment,
                                color: Colors.green.shade100,
                                route: "/assignAssignment"),
                            _DashboardItem(
                                title: "Send Message\n($messagesCount)",
                                icon: Icons.message,
                                color: Colors.orange.shade100,
                                route: "/sendMessage"),
                            _DashboardItem(
                                title: "Profile",
                                icon: Icons.person,
                                color: Colors.purple.shade100,
                                route: "/profile"),
                          ];

                          return GridView.builder(
                            itemCount: items.length,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, item.route),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: item.color,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 3,
                                          offset: Offset(2, 2)),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(item.icon,
                                          size: 36, color: Colors.indigo),
                                      const SizedBox(height: 8),
                                      Text(
                                        item.title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  _DashboardItem(
      {required this.title,
        required this.icon,
        required this.color,
        required this.route});
}
