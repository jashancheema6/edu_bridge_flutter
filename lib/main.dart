import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';     // <-- REQUIRED
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/theme_provider.dart';

import 'routes.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 THIS IS THE IMPORTANT FIX
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const EduBridge());
}

class EduBridge extends StatelessWidget {
  const EduBridge({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "EduBridge",

            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,

            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,

            initialRoute: "/splash",
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
