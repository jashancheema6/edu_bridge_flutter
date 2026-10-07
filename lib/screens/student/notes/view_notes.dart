import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewNotesScreen extends StatelessWidget {
  const ViewNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesCollection = FirebaseFirestore.instance.collection('notes');

    return Scaffold(
      appBar: AppBar(
        title: const Text('View Notes'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: notesCollection.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notes available.'));
          }

          final notes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              final title = note['title'] ?? 'No Title';
              final description = note['description'] ?? 'No Description';
              final fileUrl = note['fileUrl']; // optional

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(description),
                  trailing: fileUrl != null
                      ? IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {
                      // handle file download or open
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Download functionality not implemented.')),
                      );
                    },
                  )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
