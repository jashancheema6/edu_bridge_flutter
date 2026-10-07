import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String fileUrl; // link to PDF or doc
  final String uploadedBy; // teacher id
  final DateTime uploadedAt; // upload timestamp

  NoteModel({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.uploadedBy,
    DateTime? uploadedAt,
  }) : uploadedAt = uploadedAt ?? DateTime.now();

  // Allows updating fields easily
  NoteModel copyWith({
    String? id,
    String? title,
    String? fileUrl,
    String? uploadedBy,
    DateTime? uploadedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      fileUrl: fileUrl ?? this.fileUrl,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'fileUrl': fileUrl,
      'uploadedBy': uploadedBy,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
    };
  }

  // Create NoteModel from Firestore document
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    final ts = map['uploadedAt'];
    DateTime uploadedAt;

    if (ts is Timestamp) {
      uploadedAt = ts.toDate();
    } else if (ts is DateTime) {
      uploadedAt = ts;
    } else {
      uploadedAt = DateTime.now();
    }

    return NoteModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      uploadedBy: map['uploadedBy'] ?? '',
      uploadedAt: uploadedAt,
    );
  }
}
