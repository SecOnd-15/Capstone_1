import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme/app_theme.dart';
import 'models/user_session.dart';
import 'screens/auth/login_screen.dart';
import 'screens/navigation/main_navigation.dart';
import 'screens/admin/admin_main_navigation.dart';

import 'screens/landing/landing_screen.dart';
import 'screens/auth/registration_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations for mobile
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const GranVerdeApp());
}

class GranVerdeApp extends StatelessWidget {
  const GranVerdeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gran Verde Concierge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LandingScreen(),
      routes: {
        '/landing': (context) => const LandingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/home': (context) => UserSession.instance.isAdminOrStaff
            ? const AdminMainNavigation()
            : const MainNavigation(),
        '/admin': (context) => const AdminMainNavigation(),
      },
    );
  }
}
