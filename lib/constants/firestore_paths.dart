class FirestorePaths {
  /// User collections
  static const String students = "students";
  static const String teachers = "teachers";

  /// Notes collections
  static const String notes = "notes";
  static const String notesDownloads = "notes_downloads";

  /// Assignments collections
  static const String assignments = "assignments";
  static const String submittedAssignments = "submitted_assignments";

  /// Announcements / Notices
  static const String announcements = "announcements";

  /// Chats (optional)
  static const String chats = "chats";

  /// Storage paths
  static const String notesStorage = "notes_files";
  static const String assignmentStorage = "assignment_files";
  static const String profileImages = "profile_images";

  /// Helper Paths for Documents
  static String studentDoc(String uid) => "$students/$uid";
  static String teacherDoc(String uid) => "$teachers/$uid";
  static String noteDoc(String noteId) => "$notes/$noteId";
  static String assignmentDoc(String assignmentId) =>
      "$assignments/$assignmentId";
}
