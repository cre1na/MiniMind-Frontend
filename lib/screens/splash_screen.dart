import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset("assets/splash_video.mp4");

    // EMNİYET KİLİDİ: Video 3 saniye içinde açılmazsa, zorla navigasyon yap.
    // Bu sayede "Yanıt Vermiyor" hatasından kurtuluruz.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_isInitialized) {
        debugPrint("Video çok yavaş, ana ekrana geçiliyor...");
        _handleNavigation();
      }
    });

    try {
      await _controller.initialize();
      if (!mounted) return;

      setState(() {
        _isInitialized = true;
      });

      _controller.setLooping(false);
      _controller.play();

      _controller.addListener(() {
        if (!mounted) return;
        if (_controller.value.position >= _controller.value.duration) {
          _handleNavigation();
        }
      });
    } catch (e) {
      debugPrint("Video hatası: $e");
      _handleNavigation(); // Hata varsa bekleme, direkt geç
    }
  }

  Future<void> _handleNavigation() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();

    // --- SUNUM / TEST İÇİN EKLENEN KOD ---
    // Uygulama her açıldığında cihazın hafızasını sıfırlar (Sanki hep ilk defa giriyormuş gibi)
    await prefs.setBool('isFirstTime', true);
    // ------------------------------------

    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isFirstTime) {
      Navigator.pushReplacementNamed(context, '/onboarding1');
    } else if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/profile');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(219, 221, 225, 1),
      body: Center(
        child: _isInitialized
            ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            : Lottie.asset(
                'assets/lottie/loading_dots.json',
                width: 150,
                height: 60,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
