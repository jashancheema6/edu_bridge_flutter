import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/note_model.dart';

class ViewNotes extends StatefulWidget {
  const ViewNotes({super.key});

  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> with SingleTickerProviderStateMixin {
  late TabController tabController;
  String searchQuery = "";

  final List<Color> pastelColors = [
    Colors.pink.shade50,
    Colors.blue.shade50,
    Colors.green.shade50,
    Colors.yellow.shade50,
    Colors.purple.shade50,
    Colors.orange.shade50,
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  Future<void> openFile(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Cannot open file")));
    }
  }

  List<NoteModel> filterNotes(List<NoteModel> notes) {
    if (searchQuery.isEmpty) return notes;
    return notes
        .where((note) => note.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  List<NoteModel> sortByRecent(List<NoteModel> notes) {
    final sorted = [...notes];
    sorted.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "All Notes"),
            Tab(text: "Recent"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search notes...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
            ),
          ),

          // Notes list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notes')
                  .orderBy('uploadedAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final notes = snapshot.data!.docs.map((doc) {
                  return NoteModel(
                    id: doc.id,
                    title: doc['title'] ?? 'Untitled',
                    fileUrl: doc['fileUrl'] ?? '',
                    uploadedBy: doc['uploadedBy'] ?? 'Unknown',
                    uploadedAt: (doc['uploadedAt'] as Timestamp).toDate(),
                  );
                }).toList();

                final allNotes = filterNotes(notes);
                final recentNotes = sortByRecent(allNotes);

                return TabBarView(
                  controller: tabController,
                  children: [
                    // All Notes Tab
                    allNotes.isEmpty
                        ? const Center(child: Text("No notes found"))
                        : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: allNotes.length,
                      itemBuilder: (context, index) {
                        final note = allNotes[index];
                        final color = pastelColors[index % pastelColors.length];
                        return Card(
                          color: color,
                          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.indigo.shade100,
                              child: const Icon(Icons.picture_as_pdf, color: Colors.red),
                            ),
                            title: Text(note.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, color: Colors.indigo)),
                            subtitle: Text(
                              "Uploaded by: ${note.uploadedBy}\nDate: ${note.uploadedAt.toLocal().toString().split(' ')[0]}",
                              style: const TextStyle(fontSize: 13, color: Colors.black87),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.download, color: Colors.indigo),
                              onPressed: () => openFile(note.fileUrl),
                            ),
                          ),
                        );
                      },
                    ),

                    // Recent Notes Tab
                    recentNotes.isEmpty
                        ? const Center(child: Text("No recent notes"))
                        : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: recentNotes.length,
                      itemBuilder: (context, index) {
                        final note = recentNotes[index];
                        final color = pastelColors[index % pastelColors.length];
                        return Card(
                          color: color,
                          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange.shade100,
                              child: const Icon(Icons.picture_as_pdf, color: Colors.red),
                            ),
                            title: Text(note.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, color: Colors.orange)),
                            subtitle: Text(
                              "Uploaded by: ${note.uploadedBy}\nDate: ${note.uploadedAt.toLocal().toString().split(' ')[0]}",
                              style: const TextStyle(fontSize: 13, color: Colors.black87),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.download, color: Colors.orange),
                              onPressed: () => openFile(note.fileUrl),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
