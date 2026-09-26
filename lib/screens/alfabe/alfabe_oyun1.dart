import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/game_model.dart';
import '../../data/game_pool.dart';
import '../../data/user_data.dart';
import 'package:minimind/screens/oyunbitis.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../services/game_data_service.dart';

class AlfabeOyun1 extends StatefulWidget {
  const AlfabeOyun1({super.key});

  @override
  State<AlfabeOyun1> createState() => _AlfabeOyun1State();
}

class _AlfabeOyun1State extends State<AlfabeOyun1> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer effectPlayer = AudioPlayer();

  late AlfabeOyun1Model currentData;
  bool isLoaded = false;
  bool _yildizHarcandi = false; // GÜVENLİK KİLİDİ

  List<AlfabeOyun1Model> sorulacakSorular = [];
  int soruIndex = 0;

  String? selectedPath;
  bool? isCorrect;
  bool showLottie = false;

  int dogruSayisi = 0;
  int yanlisSayisi = 0;

  @override
  void initState() {
    super.initState();
    // Build bittikten sonra sadece 1 kez çalışması için kilitliyoruz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_yildizHarcandi) {
        _baslat();
      }
    });
  }

  void _baslat() {
    // Çift kontrol: Eğer zaten harcandıysa veya sayfa kapandıysa çık
    if (_yildizHarcandi || !mounted) return;

    bool basarili = UserData.harca();

    if (!basarili) {
      if (mounted) Navigator.of(context).pop();
    } else {
      // Kilidi hemen kapatıyoruz ki fonksiyon tekrar tetiklenmesin
      setState(() {
        _yildizHarcandi = true;
      });

      List<AlfabeOyun1Model> hamHavuz = List.from(
        GamePoolAlfabeOyun1.alfabeType1Pool,
      );

      const kabulEdilenler = ['u1', 'ü1', 'v1', 'y1', 'z1'];

      sorulacakSorular = hamHavuz.where((soru) {
        String harf = soru.charImage
            .split('/')
            .last
            .split('.')
            .first
            .toLowerCase();
        return kabulEdilenler.contains(harf);
      }).toList();

      sorulacakSorular.shuffle();
      soruIndex = 0;
      _soruyuGetir();
    }
  }

  Future<void> _soruyuGetir() async {
    if (soruIndex >= sorulacakSorular.length) {
      if (mounted) {
        await GameDataService.saveGameResult(
          gameName: "Alfabe Oyun 1",
          correctAnswers: dogruSayisi,
          wrongAnswers: yanlisSayisi,
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const OyunBitis(oynananOyun: "Alfabe Oyun 1"),
            ),
          );
        }
      }
      return;
    }

    setState(() {
      currentData = sorulacakSorular[soruIndex];
      currentData.soundOptions.shuffle();
      isLoaded = true;
      selectedPath = null;
      isCorrect = null;
      showLottie = false;
    });
  }

  void _sesDinle(String path) async {
    await audioPlayer.stop();
    String cleanPath = path.replaceFirst('assets/', '');
    if (!cleanPath.contains('alfabeOyun1/')) {
      cleanPath = 'alfabeOyun1/$cleanPath';
    }
    await audioPlayer.play(AssetSource(cleanPath));
    setState(() {
      selectedPath = path;
    });
  }

  void _cevapOnayla() async {
    if (selectedPath == null || isCorrect == true) return;

    if (selectedPath == currentData.correctSound) {
      dogruSayisi++;

      setState(() {
        isCorrect = true;
        showLottie = true;
      });
      await effectPlayer.play(
        AssetSource('soundEffects/correct_soundeffect.mp3'),
      );
      soruIndex++;
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) _soruyuGetir();
      });
    } else {
      yanlisSayisi++;

      String hataliHarf = currentData.charImage
          .split('/')
          .last
          .split('.')
          .first
          .replaceAll(RegExp(r'[0-9]'), '')
          .toUpperCase();

      _harfHatasiniKaydet(hataliHarf);

      setState(() {
        isCorrect = false;
      });
      await effectPlayer.play(
        AssetSource('soundEffects/wrong_soundeffect.mp3'),
      );
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            selectedPath = null;
            isCorrect = null;
          });
        }
      });
    }
  }

  Future<void> _harfHatasiniKaydet(String harf) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('harf_analizi')
          .doc(harf);

      await docRef.set({
        'hataSayisi': FieldValue.increment(1),
        'sonHataTarihi': DateTime.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Harf hatası kaydedilemedi: $e");
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(220, 238, 246, 1),
        body: Center(
          child: Lottie.asset(
            'assets/lottie/loading_animation.json', // LOADING ANIMASYONU
            width: 200,
            height: 200,
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: Image.asset(
                      currentData.charImage,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 100),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80.0),
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 30,
                              crossAxisSpacing: 20,
                              childAspectRatio: 1.3,
                            ),
                        itemCount: currentData.soundOptions.length,
                        itemBuilder: (context, index) =>
                            _buildSoundButton(currentData.soundOptions[index]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: _buildConfirmButton(),
                  ),
                ],
              ),
            ),
          ),
          if (showLottie)
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Lottie.asset(
                  'assets/lottie/confetti.json',
                  repeat: false,
                  width: 400,
                  height: 400,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSoundButton(String path) {
    bool isSelected = selectedPath == path;
    Color borderColor = const Color.fromRGBO(120, 214, 255, 1);
    Color bgColor = const Color.fromRGBO(220, 238, 246, 1);

    if (isSelected) {
      if (isCorrect == true) {
        borderColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.3);
      } else if (isCorrect == false) {
        borderColor = Colors.red;
        bgColor = Colors.red.withOpacity(0.3);
      } else {
        bgColor = const Color.fromRGBO(245, 159, 179, 1);
      }
    }

    return GestureDetector(
      onTap: () => _sesDinle(path),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: borderColor, width: 17),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: SizedBox(
            width: 60,
            height: 50,
            child: Image.asset('assets/sound.png', fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return GestureDetector(
      onTap: _cevapOnayla,
      child: AnimatedScale(
        scale: selectedPath != null ? 1.0 : 0.85,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: selectedPath != null
                ? const Color(0xFFED7B96)
                : Colors.grey[400],
            shape: BoxShape.circle,
            boxShadow: [
              if (selectedPath != null)
                BoxShadow(
                  color: const Color(0xFFED7B96).withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.check_rounded, color: Colors.white, size: 50),
          ),
        ),
      ),
    );
  }
}
