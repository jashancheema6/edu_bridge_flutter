import 'package:flutter/material.dart';

class AssignmentCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onDownload;

  const AssignmentCard({
    super.key,
    required this.title,
    required this.description,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.indigo.shade100,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Optional: Leading Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.assignment, color: Colors.indigo),
            ),
            const SizedBox(width: 12),
            // Title & Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description,
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade700)),
                ],
              ),
            ),
            // Download Button
            IconButton(
              icon: const Icon(Icons.download, color: Colors.indigo),
              tooltip: "Download Assignment",
              onPressed: onDownload,
            ),
          ],
        ),
      ),
    );
  }
}
