import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatelessWidget {
  final String fileUrl; // URL or local path

  const PdfViewer({super.key, required this.fileUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Viewer"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: SfPdfViewer.network(
        fileUrl,
        onDocumentLoadFailed: (details) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to load PDF: ${details.error}"),
            ),
          );
        },
      ),
    );
  }
}
