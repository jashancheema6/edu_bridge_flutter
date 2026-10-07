import 'package:flutter/material.dart';

// Auth Screens
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_options_screen.dart';
import 'screens/auth/student_signup_screen.dart';
import 'screens/auth/teacher_signup_screen.dart';

// Student Screens
import 'screens/student/home/student_home.dart';
import 'screens/student/assignments/view_assignment.dart';
import 'screens/student/assignments/upload_assignment.dart';
import 'screens/common/notification_screen.dart';

// Teacher Screens
import 'screens/teacher/home/teacher_home.dart';
import 'screens/teacher/notes/upload_notes.dart';
import 'screens/teacher/assignments/assign_assignment.dart';
import 'screens/teacher/messages/send_message.dart';

// Common Screens
import 'screens/common/splash_screen.dart';
import 'screens/common/profile.dart';
import 'screens/common/pdf_viewer.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    // Splash / Auth
    "/splash": (context) => const SplashScreen(),
    "/login": (context) => const LoginScreen(),

    // Multi-page Signup Flow
    "/signup-options": (context) => const SignupOptionsScreen(),
    "/student-signup": (context) => const StudentSignupScreen(),
    "/teacher-signup": (context) => const TeacherSignupScreen(),

    // Student
    "/studentHome": (context) => const StudentHome(),
    "/viewAssignment": (context) => const ViewAssignment(),
    "/uploadAssignment": (context) => const UploadAssignment(),
    "/notifications": (context) => const NotificationsScreen(),

    // Teacher
    "/teacherHome": (context) => const TeacherHome(),
    "/uploadNotes": (context) => UploadNotes(),
    "/assignAssignment": (context) => const AssignAssignment(),
    "/sendMessage": (context) => const SendMessage(),

    // Common
    "/profile": (context) => const ProfilePage(),
    "/pdfViewer": (context) => const PdfViewer(fileUrl: "example.pdf"),
  };
}
