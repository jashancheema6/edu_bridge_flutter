class AssignmentModel {
  final String id;
  final String title;
  final String fileUrl; // link to assignment file
  final String assignedBy; // teacher id
  final String assignedTo; // student id
  final bool submitted; // student submission status

  AssignmentModel({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.assignedBy,
    required this.assignedTo,
    this.submitted = false,
  });

  // Convert AssignmentModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'fileUrl': fileUrl,
      'assignedBy': assignedBy,
      'assignedTo': assignedTo,
      'submitted': submitted,
    };
  }

  // Create AssignmentModel from Firestore document
  factory AssignmentModel.fromMap(Map<String, dynamic> map) {
    return AssignmentModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      assignedBy: map['assignedBy'] ?? '',
      assignedTo: map['assignedTo'] ?? '',
      submitted: map['submitted'] ?? false,
    );
  }
}
