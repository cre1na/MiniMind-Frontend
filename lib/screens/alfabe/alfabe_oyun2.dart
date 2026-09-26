import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// YENİ EKLENEN: Harf analizi için Firebase importları
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/game_model.dart';
import '../../data/game_pool.dart';
import '../../data/user_data.dart';
import 'package:minimind/screens/oyunbitis.dart';
import 'package:audioplayers/audioplayers.dart';
// VERİTABANI SERVİSİMİZİ İÇERİ AKTARIYORUZ
import '../../services/game_data_service.dart';

class AlfabeOyun2 extends StatefulWidget {
  const AlfabeOyun2({super.key});

  @override
  State<AlfabeOyun2> createState() => _AlfabeOyun2State();
}

class _AlfabeOyun2State extends State<AlfabeOyun2> {
  final AudioPlayer audioPlayer = AudioPlayer();

  late AlfabeOyun2Model currentData;
  bool isLoaded = false;
  bool oyunBitti = false;

  List<AlfabeOyun2Model> sorulacakSorular = [];
  int soruIndex = 0;

  // Durum takibi
  String? selectedPath; // Tıklanan buton
  bool? isCorrect; // Tıklanan buton dogru mu
  bool showLottie = false; // Lottie gözükecek mi (cevap doğru mu)

  // YAPAY ZEKA İÇİN İSTATİSTİK SAYAÇLARIMIZ
  int dogruSayisi = 0;
  int yanlisSayisi = 0;

  @override
  void initState() {
    super.initState();

    // 1. DÜZELTME: Kilitlenmeyi önlemek için işlemleri ekran çizildikten sonraya alıyoruz.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool yildizVarMi = UserData.harca();

      if (!yildizVarMi) {
        if (mounted) {
          Navigator.of(context).pop(); // Yıldız yoksa güvenle çık
        }
      } else {
        // İşlemciyi rahatlatmak için oyun verilerini çok kısa bir gecikmeyle yüklüyoruz.
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              sorulacakSorular = List.from(GamePoolAlfabeOyun2.alfabeType2Pool);
              sorulacakSorular.shuffle();
              soruIndex = 0;
              dogruSayisi = 0; // Oyun başlarken sayaçları sıfırla
              yanlisSayisi = 0;
              _oyunuBaslat();
            });
          }
        });
      }
    });
  }

  // async VE await EKLENDİ (Veritabanı kaydını beklemek için)
  Future<void> _oyunuBaslat() async {
    if (soruIndex >= sorulacakSorular.length) {
      
      debugPrint("🏁 Alfabe Oyun 2 bitti, kayıt başlıyor...");

      // YAPAY ZEKA İÇİN VERİLERİ FİRESTORE'A GÖNDERİYORUZ
      await GameDataService.saveGameResult(
        gameName: "Alfabe Oyun 2",
        correctAnswers: dogruSayisi,
        wrongAnswers: yanlisSayisi,
      );

      debugPrint("✅ Kayıt bitti, yönlendirme yapılıyor...");

      if (mounted) {
        // Mevcut ekranı kapat ve oyunbitis ekranına geç
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OyunBitis(oynananOyun: "Alfabe Oyun 2")));
      }
      return;
    }

    setState(() {
      currentData = sorulacakSorular[soruIndex];
      currentData.options.shuffle();

      isLoaded = true;
      selectedPath = null;
      isCorrect = null;
      showLottie = false;
    });
  }

  void _cevapKontrol(String path) {
    if (selectedPath != null) return;

    setState(() {
      selectedPath = path;
      if (path == currentData.correctLetter) {
        isCorrect = true;
        showLottie = true;
        
        // DOĞRU CEVAP VERİLDİ - SAYACI ARTIR
        dogruSayisi++;

        audioPlayer.play(AssetSource('soundEffects/correct_soundeffect.mp3'));

        soruIndex++;

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) _oyunuBaslat();
        });
      } else {
        isCorrect = false;
        
        // YANLIŞ CEVAP VERİLDİ - SAYACI ARTIR
        yanlisSayisi++;

        // YENİ EKLENEN KISIM: Bilmesi gereken doğru harfi bul ve hatayı Firebase'e kaydet
        String hataliHarf = currentData.correctLetter
            .split('/')
            .last
            .split('.')
            .first
            .replaceAll(RegExp(r'[0-9]'), '') // Varsa sonundaki sayıyı sil
            .toUpperCase();

        _harfHatasiniKaydet(hataliHarf);

        audioPlayer.play(AssetSource('soundEffects/wrong_soundeffect.mp3'));

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              selectedPath = null;
              isCorrect = null;
            });
          }
        });
      }
    });
  }

  // YENİ EKLENEN KISIM: Harf özelinde hata kaydını Firebase'e işleyen fonksiyon
  Future<void> _harfHatasiniKaydet(String harf) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('harf_analizi')
          .doc(harf);

      // increment(1) ile o harfin hata sayısını 1 artırıyoruz
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 2. DÜZELTME: build içinde Navigator.pop tetikleyen tehlikeli kod bloğu kaldırıldı.
    if (!isLoaded) {
      return const Scaffold(
        backgroundColor: Color.fromRGBO(219, 221, 225, 1),
        body: Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
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
                  SizedBox(
                    width: 350,
                    height: 350,
                    child: Image.asset(
                      currentData.mainImage,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      // Hata koruması eklendi (Görsel yoksa çökmeyi önler)
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 100),
                    ),
                  ),
                  Text(
                    currentData.title,
                    style: const TextStyle(
                      fontSize: 40,
                      fontFamily: 'LexendDeca',
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF912C21),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    flex: 4,
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: currentData.options.length,
                      itemBuilder: (context, index) {
                        final path = currentData.options[index];
                        return _buildButton(path);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Lottie Animasyonu
          if (showLottie)
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Lottie.asset(
                  'assets/lottie/confetti.json',
                  repeat: false,
                  width: 350,
                  height: 350,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildButton(String path) {
    bool isThisSelected = selectedPath == path;

    Color borderColor = const Color.fromRGBO(120, 214, 255, 1);
    Color bgColor = const Color.fromRGBO(220, 238, 246, 1);

    if (isThisSelected) {
      if (isCorrect == true) {
        borderColor = Colors.green;
        bgColor = Colors.green.withOpacity(1);
      } else if (isCorrect == false) {
        borderColor = Colors.red;
        bgColor = Colors.red.withOpacity(1);
      }
    }

    return GestureDetector(
      onTap: () => _cevapKontrol(path),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: borderColor, width: 8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            path,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            // Hata koruması eklendi
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}