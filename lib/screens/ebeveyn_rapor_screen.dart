import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/gemini_service.dart';

class EbeveynRaporScreen extends StatefulWidget {
  final String cocukAdi;
  final String kategoriAdi;

  const EbeveynRaporScreen({
    super.key,
    required this.cocukAdi,
    required this.kategoriAdi,
  });

  @override
  State<EbeveynRaporScreen> createState() => _EbeveynRaporScreenState();
}

class _EbeveynRaporScreenState extends State<EbeveynRaporScreen> {
  String _aiRaporu = "Yapay zeka verileri analiz ediyor...\nLütfen bekleyin.";
  bool _yukleniyor = true;

  int _toplamDogru = 0;
  int _toplamYanlis = 0;
  int _oynananOyunSeviyesi = 0;
  double _basariYuzdesi = 0;

  // DİNAMİK HARF DEĞİŞKENLERİ
  String _enCokHataYapilanHarf = "-";

  // Tüm alfabe başlangıçta 1.0 (Tam dolu) olarak ayarlandı
  Map<String, double> _harfBasarilari = {
    'A': 1.0,
    'B': 1.0,
    'C': 1.0,
    'Ç': 1.0,
    'D': 1.0,
    'E': 1.0,
    'F': 1.0,
    'G': 1.0,
    'H': 1.0,
    'I': 1.0,
    'İ': 1.0,
    'J': 1.0,
    'K': 1.0,
    'L': 1.0,
    'M': 1.0,
    'N': 1.0,
    'O': 1.0,
    'Ö': 1.0,
    'P': 1.0,
    'R': 1.0,
    'S': 1.0,
    'Ş': 1.0,
    'T': 1.0,
    'U': 1.0,
    'Ü': 1.0,
    'V': 1.0,
    'Y': 1.0,
    'Z': 1.0,
  };

  @override
  void initState() {
    super.initState();
    _verileriCekVeRaporla();
    _harfAnaliziniYukle(); // Harf grafiğini dolduracak fonksiyonu çağırıyoruz
  }

  // YENİ: Firebase'den hata yapılan harfleri çekip grafiği güncelleyen fonksiyon
  // YENİ: Firebase'den hata yapılan harfleri çekip grafiği güncelleyen fonksiyon
  Future<void> _harfAnaliziniYukle() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('harf_analizi')
          .get();

      if (snapshot.docs.isNotEmpty) {
        double enDusukOran = 1.1;
        // DÜZELTME: Artık tek harf değil, eşit olanları tutmak için liste kullanıyoruz
        List<String> enHataliHarfler = [];

        for (var doc in snapshot.docs) {
          String harf = doc.id.toUpperCase();
          int hata = (doc.data()['hataSayisi'] ?? 0) as int;

          // Her 1 hata barı %20 oranında kısaltır. (0.0'ın altına düşmesin diye clamp kullandık)
          double oran = (1.0 - (hata * 0.2)).clamp(0.0, 1.0);

          if (mounted) {
            setState(() {
              _harfBasarilari[harf] = oran;

              // Eğer yeni ve DAHA DÜŞÜK bir oran bulduysak
              if (oran < enDusukOran) {
                enDusukOran = oran;
                enHataliHarfler = [harf]; // Listeyi sıfırla ve yeni harfi ekle
              }
              // Eğer mevcut en düşük orana EŞİT başka bir harf bulduysak (ve hata yapılmışsa)
              else if (oran == enDusukOran && oran < 1.0) {
                enHataliHarfler.add(harf); // Listeye yanına ekle
              }
            });
          }
        }

        if (mounted) {
          setState(() {
            // Eğer listemizde harf varsa aralarına virgül koyarak yaz (Örn: "C, V")
            if (enDusukOran < 1.0 && enHataliHarfler.isNotEmpty) {
              _enCokHataYapilanHarf = enHataliHarfler.join(", ");
            } else {
              // Hiç hata yoksa (herkes 1.0 ise)
              _enCokHataYapilanHarf = "Yok ✨";
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Harf verileri çekilemedi: $e");
    }
  }

  Future<void> _verileriCekVeRaporla() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('game_history')
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          String dbGameName = doc['gameName']?.toString().toLowerCase() ?? "";
          String arananKategori = widget.kategoriAdi.toLowerCase();

          if (dbGameName.contains(arananKategori)) {
            _toplamDogru += (doc['correctAnswers'] ?? 0) as int;
            _toplamYanlis += (doc['wrongAnswers'] ?? 0) as int;
            _oynananOyunSeviyesi++;
          }
        }

        if (_oynananOyunSeviyesi == 0) {
          if (mounted) {
            setState(() {
              _aiRaporu =
                  "${widget.kategoriAdi} kategorisinde henüz oyun oynanmamış.";
              _yukleniyor = false;
            });
          }
          return;
        }

        int toplamSoru = _toplamDogru + _toplamYanlis;
        _basariYuzdesi = toplamSoru > 0 ? (_toplamDogru / toplamSoru) * 100 : 0;

        final rapor = await GeminiService.ebeveynRaporuOlustur(
          cocukAdi: widget.cocukAdi,
          oyunAdi: widget.kategoriAdi,
          dogruSayisi: _toplamDogru,
          yanlisSayisi: _toplamYanlis,
          basariOrani: _basariYuzdesi.round(),
        );

        if (mounted) {
          setState(() {
            _aiRaporu = rapor;
            _yukleniyor = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _aiRaporu = "Henüz analiz edilecek kadar oyun verisi birikmedi.";
            _yukleniyor = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _aiRaporu = "Rapor hazırlanırken bir hata oluştu: $e";
          _yukleniyor = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String basHarf = widget.cocukAdi.isNotEmpty
        ? widget.cocukAdi[0].toUpperCase()
        : "Ç";

    return Scaffold(
      backgroundColor: const Color.fromRGBO(253, 251, 243, 1),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Üst Kısım: Geri Butonu
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black54,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // 1. Konuşma Balonu (İsim ve Harf)
            _buildSpeechBubble(basHarf, widget.cocukAdi),
            const SizedBox(height: 15),

            // 2. Kategori Etiketi (Alfabe vb.)
            _buildCategoryPill(widget.kategoriAdi),
            const SizedBox(height: 10),

            // 3. Ortadaki Tavşan Görseli
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset("assets/minidash.png", fit: BoxFit.contain),
              ),
            ),

            // 4. Alt Kısım: Açık Mavi Rapor Alanı
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(220, 238, 246, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(53),
                    topRight: Radius.circular(53),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                    left: 25,
                    right: 25,
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dinamik İstatistik Metinleri
                        const SizedBox(height: 15),
                        Text(
                          "En çok hata yaptığı harf: $_enCokHataYapilanHarf",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Harf Başarı Grafiği (Bar Chart)
                        SizedBox(
                          height: 120, // Grafiğin toplam yüksekliği
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _harfBasarilari.length,
                            itemBuilder: (context, index) {
                              String harf = _harfBasarilari.keys.elementAt(
                                index,
                              );
                              double oran = _harfBasarilari[harf]!;
                              return _buildChartBar(harf, oran);
                            },
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Gemini AI Raporu
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.auto_awesome,
                                    color: Colors.pinkAccent,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Yapay Zeka Değerlendirmesi",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: Colors.blue.shade800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _yukleniyor
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.pinkAccent,
                                      ),
                                    )
                                  : Text(
                                      _aiRaporu,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        height: 1.5,
                                        color: Color(0xFF444444),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- YARDIMCI WIDGET'LAR ---

  // Grafik Çubukları Tasarımı
  Widget _buildChartBar(String harf, double oran) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Bar (Çubuk) - Yüksekliği 'oran' değişkenine göre değişir
          Container(
            width: 16, // Çubuk kalınlığı
            height: 90 * oran, // Maksimum 90 piksel boyunda
            decoration: BoxDecoration(
              color: const Color(0xFF7CA0C7), // Tasarımdaki mavi/gri ton
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          // Altındaki Harf
          Text(
            harf,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF7CA0C7),
            ),
          ),
        ],
      ),
    );
  }

  // Ortadaki "Alfabe" vs yazan Kapsül Tasarımı
  Widget _buildCategoryPill(String kategori) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      height: 80,
      width: 250,
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
          Text(
            kategori,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF333333),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: Image.asset(
                "assets/alfabedash.png",
                width: 90,
                height: 90,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 15),

          const SizedBox(width: 15),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Image.asset(
                "assets/abc.png",
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Konuşma Balonu Tasarımı
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
        // Balonun altındaki küçük üçgen kuyruk
        CustomPaint(size: const Size(20, 15), painter: TrianglePainter()),
      ],
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
