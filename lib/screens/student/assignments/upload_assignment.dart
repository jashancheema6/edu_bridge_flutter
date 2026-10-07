import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class UploadAssignment extends StatefulWidget {
  const UploadAssignment({super.key});

  @override
  State<UploadAssignment> createState() => _UploadAssignmentState();
}

class _UploadAssignmentState extends State<UploadAssignment> {
  final TextEditingController assignmentController = TextEditingController();
  File? selectedFile;
  bool isUploading = false;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadAssignment() async {
    String name = assignmentController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter assignment name")));
      return;
    }
    if (selectedFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Select a file first")));
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      // Upload file to Firebase Storage
      String fileName = "${DateTime.now().millisecondsSinceEpoch}_${name}";
      Reference storageRef =
      FirebaseStorage.instance.ref().child("assignments/$fileName");
      UploadTask uploadTask = storageRef.putFile(selectedFile!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Save metadata to Firestore
      await FirebaseFirestore.instance.collection("assignments").add({
        "name": name,
        "fileUrl": downloadUrl,
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$name uploaded successfully!")),
      );

      setState(() {
        assignmentController.clear();
        selectedFile = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Assignment"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  )
                ],
              ),
              child: Column(
                children: [
                  // Assignment Name Input
                  TextField(
                    controller: assignmentController,
                    decoration: InputDecoration(
                      labelText: "Assignment Name",
                      labelStyle: const TextStyle(color: Colors.indigo),
                      prefixIcon: const Icon(Icons.title, color: Colors.indigo),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Select File Button
                  GestureDetector(
                    onTap: pickFile,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.upload_file, color: Colors.indigo),
                          const SizedBox(width: 10),
                          Text(
                            selectedFile != null
                                ? "File Selected"
                                : "Select File",
                            style: const TextStyle(
                              color: Colors.indigo,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Upload Button
                  GestureDetector(
                    onTap: isUploading ? null : uploadAssignment,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE0F2F1), Color(0xFFB2DFDB)],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isUploading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.indigo,
                              strokeWidth: 2,
                            ),
                          )
                              : const Icon(Icons.cloud_upload, color: Colors.indigo),
                          const SizedBox(width: 10),
                          Text(
                            isUploading
                                ? "Uploading..."
                                : "Upload Assignment",
                            style: const TextStyle(
                              color: Colors.indigo,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade100,
    );
  }
}
