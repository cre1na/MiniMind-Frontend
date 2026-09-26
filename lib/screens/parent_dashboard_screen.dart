import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ebeveyn_rapor_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  String cocukIsmi = "Çocuk";
  int bugunGecirilenDakika = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _kullaniciBilgileriniGetir();
  }

  Future<void> _kullaniciBilgileriniGetir() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        DateTime now = DateTime.now();
        String bugununTarihi =
            "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
        final sureDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('gunluk_sureler')
            .doc(bugununTarihi)
            .get();

        if (mounted) {
          setState(() {
            if (doc.exists && doc.data() != null) {
              cocukIsmi =
                  doc.data()?['childName'] ?? doc.data()?['name'] ?? "Çocuk";
              if (cocukIsmi.isNotEmpty) {
                cocukIsmi = cocukIsmi[0].toUpperCase() + cocukIsmi.substring(1);
              }
            }
            if (sureDoc.exists && sureDoc.data() != null) {
              bugunGecirilenDakika = sureDoc.data()?['gecirilenDakika'] ?? 0;
            }
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String basHarf = cocukIsmi.isNotEmpty ? cocukIsmi[0].toUpperCase() : "Ç";

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF3),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Üst Kısım: Geri Butonu
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Konuşma Balonu
          _buildSpeechBubble(basHarf, cocukIsmi),
          const SizedBox(height: 10),

          // Soru ve Çizgi
          const Text(
            "Bugün ne kadar vakit geçirdi?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(36, 27, 44, 1),
            ),
          ),
          const SizedBox(height: 1),
          Container(
            height: 3,
            width: 275,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 173, 199, 1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),

          // Süre
          Text(
            "$bugunGecirilenDakika dakika",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w300,
              color: Color.fromRGBO(36, 27, 44, 1),
            ),
          ),

          const SizedBox(height: 20),
          // Tavşan Görseli
          Expanded(
            flex: 2,
            child: Image.asset("assets/minidash.png", fit: BoxFit.contain),
          ),

          //panel katmanı
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.50,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(220, 238, 246, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(53),
                  topRight: Radius.circular(53),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    spreadRadius: 0,
                    blurRadius: 10.6,
                    offset: Offset(6, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  const Text(
                    "İlerlemeyi görmek istediğin kategoriyi seç:",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(36, 27, 44, 1),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildCategoryButton(
                          context,
                          "Alfabe",
                          "assets/alfabedash.png",
                          "assets/abc.png",
                        ),
                        _buildCategoryButton(
                          context,
                          "Hayvanlar",
                          "assets/hayvandash.png",
                          "assets/hayvanlar.png",
                        ),
                        _buildCategoryButton(
                          context,
                          "Renkler",
                          "assets/renkdash.png",
                          "assets/renkler.png",
                        ),
                        _buildCategoryButton(
                          context,
                          "Sayılar",
                          "assets/sayıdash.png",
                          "assets/sayilar.png",
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeechBubble(String harf, String isim) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFDCEEF6),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF7A8C4), width: 3),
                ),
                child: Center(
                  child: Text(
                    harf,
                    style: const TextStyle(
                      color: Color(0xFF1CB0F6),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Text(
                isim,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
        CustomPaint(size: const Size(25, 20), painter: TrianglePainter()),
      ],
    );
  }

  Widget _buildCategoryButton(
    BuildContext context,
    String baslik,
    String tavsanAsset,
    String ikonAsset,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EbeveynRaporScreen(cocukAdi: cocukIsmi, kategoriAdi: baslik),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 80,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(220, 238, 246, 1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color.fromRGBO(178, 231, 255, 1),
            width: 5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset(tavsanAsset, fit: BoxFit.contain, height: 75),
            ),
            Text(
              baslik,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF333333),
              ),
            ),
            Positioned(
              right: 10,
              child: Image.asset(ikonAsset, fit: BoxFit.contain, height: 65),
            ),
          ],
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = const Color(0xFFDCEEF6);
    var path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
