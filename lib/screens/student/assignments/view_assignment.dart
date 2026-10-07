import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewAssignment extends StatefulWidget {
  const ViewAssignment({super.key});

  @override
  State<ViewAssignment> createState() => _ViewAssignmentState();
}

class _ViewAssignmentState extends State<ViewAssignment>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final assignmentsCollection =
    FirebaseFirestore.instance.collection('assignments');

    // Colors for pending assignment containers
    final pendingColors = [
      Colors.indigo.shade50,
      Colors.purple.shade50,
      Colors.orange.shade50,
      Colors.teal.shade50,
      Colors.blue.shade50,
      Colors.yellow.shade50,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Assignments"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Submitted"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // ------------------- PENDING ASSIGNMENTS -------------------
          StreamBuilder<QuerySnapshot>(
            stream: assignmentsCollection
                .where('status', isEqualTo: 'pending')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No pending assignments."));
              }

              final pendingAssignments = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pendingAssignments.length,
                itemBuilder: (context, index) {
                  final assignment = pendingAssignments[index];
                  final title = assignment['name'] ?? 'No Title';
                  final deadline = assignment['deadline'] ?? 'No Deadline';
                  final containerColor =
                  pendingColors[index % pendingColors.length];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: containerColor.withOpacity(0.6),
                        child: const Icon(Icons.assignment, color: Colors.indigo),
                      ),
                      title: Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.indigo)),
                      subtitle: Text("Deadline: $deadline",
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black87)),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.indigo),
                        ),
                        child: const Text(
                          "Upload",
                          style: TextStyle(color: Colors.indigo),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            "/uploadAssignment",
                            arguments: assignment.id, // pass assignment ID if needed
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // ------------------- SUBMITTED ASSIGNMENTS -------------------
          StreamBuilder<QuerySnapshot>(
            stream: assignmentsCollection
                .where('status', isEqualTo: 'submitted')
                .orderBy('submittedAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No submitted assignments."));
              }

              final submittedAssignments = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: submittedAssignments.length,
                itemBuilder: (context, index) {
                  final assignment = submittedAssignments[index];
                  final title = assignment['name'] ?? 'No Title';
                  final submittedDate = assignment['submittedAt'] != null
                      ? (assignment['submittedAt'] as Timestamp).toDate()
                      : DateTime.now();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade100,
                        child: const Icon(Icons.check, color: Colors.green),
                      ),
                      title: Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green)),
                      subtitle: Text(
                          "Submitted: ${submittedDate.day}-${submittedDate.month}-${submittedDate.year}",
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black87)),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
