import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:minimind/screens/parent_dashboard_screen.dart';
import 'core/firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/1.onboarding_screen.dart';
import 'screens/2.onboarding_screen.dart';
import 'screens/3.onboarding_screen.dart';
import 'screens/profile_create_screen.dart';
import 'screens/loginscreen.dart';
import 'screens/signinscreen.dart';
import 'screens/profile_screen.dart';
import 'screens/main_screen.dart';
import 'screens/loading.dart';
import 'screens/forgotpassword_screen.dart';
import 'screens/repassword_screen.dart';
import 'screens/oyunbitis.dart';
import 'screens/ebeveyn_rapor_screen.dart';
import 'screens/oyun-giris-ekranlari/alphabet_screen.dart';
import 'screens/oyun-giris-ekranlari/animals_screen.dart';
import 'screens/alfabe/alfabe_oyun1.dart';
import 'screens/alfabe/alfabe_oyun2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase henüz web için hazir değil: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiniMind',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        fontFamily: 'LexendDeca',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FBFF),
      ),

      // TEST:
      // home: const AlphabetScreen(),
      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(),
        '/profile': (context) => const ProfileSelectionScreen(),
        '/parent_dashboard': (context) => const ParentDashboardScreen(),
        '/onboarding1': (context) => const OnboardingScreen1(),
        '/onboarding2': (context) => const OnboardingScreen2(),
        '/onboarding3': (context) => const OnboardingScreen3(),
        '/signin': (context) => const SigninScreen(),
        '/login': (context) => const LoginScreen(),
        '/profilecreate': (context) => const ProfileCreateScreen(),
        '/forgotpass': (context) => const ForgotPasswordScreen(),
        '/repassword': (context) => const ForgotPassSuccessScreen(),
        '/main': (context) => const MainMenuScreen(),
        '/loading': (context) => const LoadingScreen(),
        '/alphabet': (context) => const AlphabetScreen(),
        '/animals': (context) => const AnimalsScreen(),
        '/oyun1': (context) => const AlfabeOyun1(),
        '/oyun2': (context) => const AlfabeOyun2(),
      },
    );
  }
}
