import 'package:cloud_firestore/cloud_firestore.dart';

class SubmissionModel {
  final String id;           // Submission ID (Firestore doc ID)
  final String assignmentId; // Linked assignment ID
  final String studentId;    // Student who submitted
  final String fileUrl;      // URL of submitted file
  final DateTime submittedAt; // Timestamp of submission
  final bool graded;          // Whether teacher has graded it (optional)
  final double? grade;        // Grade (optional)

  SubmissionModel({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.fileUrl,
    DateTime? submittedAt,
    this.graded = false,
    this.grade,
  }) : submittedAt = submittedAt ?? DateTime.now();

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assignmentId': assignmentId,
      'studentId': studentId,
      'fileUrl': fileUrl,
      'submittedAt': Timestamp.fromDate(submittedAt),
      'graded': graded,
      'grade': grade,
    };
  }

  // Create SubmissionModel from Firestore document
  factory SubmissionModel.fromMap(Map<String, dynamic> map) {
    final ts = map['submittedAt'];
    DateTime submittedTime;

    if (ts is Timestamp) {
      submittedTime = ts.toDate();
    } else if (ts is DateTime) {
      submittedTime = ts;
    } else {
      submittedTime = DateTime.now();
    }

    return SubmissionModel(
      id: map['id'] ?? '',
      assignmentId: map['assignmentId'] ?? '',
      studentId: map['studentId'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      submittedAt: submittedTime,
      graded: map['graded'] ?? false,
      grade: map['grade'] != null ? (map['grade'] as num).toDouble() : null,
    );
  }
}
