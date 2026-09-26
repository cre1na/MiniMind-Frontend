import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:lottie/lottie.dart';
import 'package:minimind/screens/alfabe/alfabe_oyun2.dart';

class AlfabeOyun2Intro extends StatefulWidget {
  const AlfabeOyun2Intro({super.key});

  @override
  State<AlfabeOyun2Intro> createState() => _AlfabeOyun2IntroState();
}

class _AlfabeOyun2IntroState extends State<AlfabeOyun2Intro> {
  late VideoPlayerController _controller;
  bool _isNavigating = false; // YENİ: Mükerrer geçişi engelleyen kilit

  @override
  void initState() {
    super.initState();

    // Video başlangıç
    _controller = VideoPlayerController.asset('assets/alfabe2_intro.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    // Video bitiş dinleyicisi
    _controller.addListener(() {
      // Video sona ulaştığında
      if (_controller.value.position >= _controller.value.duration) {
        // Eğer geçiş henüz başlamadıysa içeri gir
        if (!_isNavigating) {
          setState(() {
            _isNavigating = true; // Kapıyı hemen kilitle
          });
          _oyunaGec();
        }
      }
    });
  }

  void _oyunaGec() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AlfabeOyun2()),
      );
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
      backgroundColor: const Color.fromRGBO(219, 220, 224, 1),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
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
