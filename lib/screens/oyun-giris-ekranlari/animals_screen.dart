import 'package:flutter/material.dart';
import '../../../data/user_data.dart';
import 'package:minimind/screens/parent_dashboard_screen.dart';
import 'package:minimind/services/time_tracker_service.dart';

class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});

  @override
  State<AnimalsScreen> createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 252, 246),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildHeaderCard(), // En üstteki hayvanlar başlık kartı
              const SizedBox(height: 20),

              // 1. Oyun Kartı
              _buildGameBanner(
                context: context,
                imagePath: 'assets/hayvanlar_oyun1_banner.png',
                showSound: true,
                gamePage: const Scaffold(
                  body: Center(
                    child: Text("Hayvanlar Oyunu 1 - Yapım Aşamasında"),
                  ),
                ),
                borderColor: Color.fromRGBO(120, 214, 255, 1),
              ),

              const SizedBox(height: 25),

              // 2. Oyun Kartı
              _buildGameBanner(
                context: context,
                imagePath: 'assets/hayvanlar_oyun2_banner.png',
                showSound: true,
                gamePage: const Scaffold(
                  body: Center(
                    child: Text("Hayvanlar Oyunu 2 - Yapım Aşamasında"),
                  ),
                ),
                borderColor: Color.fromRGBO(120, 214, 255, 1),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  // En üstteki "Hayvanlar" yazan başlık kısmı
  Widget _buildHeaderCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 129,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 220, 238, 246),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color.fromARGB(255, 178, 231, 255),
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
                    children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Hayvanlar",
                            style: TextStyle(
                              fontFamily: 'LexendDeca',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 36, 37, 44),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 0,
                        child: Image.asset(
                          'assets/hayvanlar.png',
                          width: 70,
                          height: 115,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 5,
                  child: Image.asset(
                    'assets/mini.png',
                    height: 141,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Ebeveyn paneli
          Column(
            children: [
              Padding(padding: const EdgeInsets.only(top: 20)),
              _buildTopMenu(),
              const SizedBox(height: 10),
              // Yıldız
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Image(
                      image: AssetImage('assets/star.png'),
                      width: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${UserData.kalanYildiz}", //yıldız sayısını çeker
                      style: const TextStyle(
                        fontFamily: 'LexendDeca',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 36, 37, 44),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Oyun Bannerları
  Widget _buildGameBanner({
    required BuildContext context,
    required String imagePath,
    required bool showSound,
    required Widget gamePage,
    required Color borderColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          //CAN SİSTEMİ KONTROLÜ
          if (UserData.kalanYildiz > 0) {
            UserData.harca(); // Yıldızı harca
            setState(() {}); // Bu ekrandaki yıldız sayısını güncelle
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => gamePage),
            ).then((_) => setState(() {})); // Oyundan dönünce yıldızı tazele
          } else {
            // Yıldız bitti uyarısı
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Yıldızların bitti! Yarın tekrar gel."), //TEST
                backgroundColor: Colors.orange,
              ),
            );
          }
        },
        child: Container(
          width: 370,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
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
              Padding(
                padding: const EdgeInsets.all(17),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey[300]),
                  ),
                ),
              ),
              Container(
                width: 370,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  border: Border.all(color: borderColor, width: 17),
                ),
              ),
              Positioned(
                right: 25,
                top: 25,
                child: Image.asset(
                  'assets/star.png',
                  width: 35,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.star, color: Colors.yellow, size: 35),
                ),
              ),
              if (showSound)
                Positioned(
                  left: 25,
                  bottom: 25,
                  child: Image.asset('assets/sound_icon.png', width: 40),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopMenu() {
    return const ParentPanelHoldButton();
  }
}

//buton sınıfı
class ParentPanelHoldButton extends StatefulWidget {
  const ParentPanelHoldButton({super.key});

  @override
  State<ParentPanelHoldButton> createState() => _ParentPanelHoldButtonState();
}

class _ParentPanelHoldButtonState extends State<ParentPanelHoldButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        TimeTrackerService.startTracking();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ParentDashboardScreen(),
          ),
        ).then((_) {
          TimeTrackerService.stopTracking();
          _controller.reset();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _controller.forward(),
      onLongPressEnd: (_) {
        if (_controller.status != AnimationStatus.completed) {
          _controller.reverse();
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          //Dolan Siyah Halka
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: CircularProgressPainter(_controller.value),
                size: const Size(35, 35),
              );
            },
          ),
          //buton tasarımı
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromRGBO(220, 238, 246, 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.menu, color: Colors.black, size: 24),
          ),
        ],
      ),
    );
  }
}

//buton etrafındaki animasyon
class CircularProgressPainter extends CustomPainter {
  final double progress;
  CircularProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // Tepe noktası (-90 derece)
      6.28319 * progress, // İlerleme miktarı (360 derece karşılığı)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
