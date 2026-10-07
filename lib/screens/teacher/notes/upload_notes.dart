import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadNotes extends StatelessWidget {
  UploadNotes({super.key});

  final List<Color> pastelColors = [
    Colors.pink.shade50,
    Colors.blue.shade50,
    Colors.green.shade50,
    Colors.yellow.shade50,
    Colors.purple.shade50,
    Colors.orange.shade50,
  ];

  // Open file using url_launcher
  Future<void> openFile(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Notes"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data!.docs;
          if (notes.isEmpty) {
            return const Center(child: Text("No notes available."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              final color = pastelColors[index % pastelColors.length];
              final title = note['title'] ?? "Untitled";
              final fileUrl = note['fileUrl'] ?? "";

              return Card(
                color: color,
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.note, color: Colors.indigo),
                  title: Text(title, style: const TextStyle(color: Colors.indigo)),
                  trailing: IconButton(
                    icon: const Icon(Icons.download, color: Colors.indigo),
                    onPressed: fileUrl.isNotEmpty
                        ? () => openFile(fileUrl)
                        : null, // Disable button if no URL
                  ),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.grey.shade100,
    );
  }
}
