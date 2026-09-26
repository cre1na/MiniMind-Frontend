import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:lottie/lottie.dart';
import 'package:minimind/screens/alfabe/alfabe_oyun1.dart';

class AlfabeOyun1Intro extends StatefulWidget {
  const AlfabeOyun1Intro({super.key});

  @override
  State<AlfabeOyun1Intro> createState() => _AlfabeOyun1IntroState();
}

class _AlfabeOyun1IntroState extends State<AlfabeOyun1Intro> {
  late VideoPlayerController _controller;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    // Video başlangıç
    _controller = VideoPlayerController.asset('assets/alfabe1_intro.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    // Video bitiş dinleyicisi
    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        if (!_isNavigating) {
          _isNavigating = true;
          _oyunaGec();
        }
      }
    });
  }

  void _oyunaGec() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AlfabeOyun1()),
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
