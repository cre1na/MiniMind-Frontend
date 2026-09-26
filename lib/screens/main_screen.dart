import 'package:flutter/material.dart';
import 'oyun-giris-ekranlari/alphabet_screen.dart';
import 'oyun-giris-ekranlari/animals_screen.dart';
// Ebeveyn Rapor ekranının ve Zamanlayıcı Servisinin importları
import 'parent_dashboard_screen.dart';
import 'package:minimind/services/time_tracker_service.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {

  @override
  void initState() {
    super.initState();
    // EKLENEN KISIM: Ana ekran açıldığında çocuğun geçirdiği süreyi saymaya başla
    TimeTrackerService.startTracking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 252, 246, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopMenu(),
              // 1. BUTON: ALFABE
              _buildManualPositionedButton(
                context,
                title: "Alfabe",
                rabbitImg: "assets/mainscreen_asset1.png",
                rightImg: "assets/abc.png",
                topPadding: 35,
                rabbitHeight: 161,
                rabbitLeft: 0,
                rabbitBottom: 0,
                rightIconHeight: 153,
                rightIconRight: 10,
                rightIconTop: -2,
                //ALFABE EKRANINA GİDİŞ
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AlphabetScreen(),
                    ),
                  );
                },
              ),

              // 2. BUTON: HAYVANLAR
              _buildManualPositionedButton(
                context,
                title: "Hayvanlar",
                rabbitImg: "assets/mainscreen_asset2.png",
                rightImg: "assets/hayvanlar.png",
                topPadding: 35,
                rabbitHeight: 145.32,
                rabbitLeft: 0,
                rabbitBottom: 0,
                rightIconHeight: 155,
                rightIconRight: 10,
                rightIconTop: -3,
                //HAYVANLAR EKRANINA GİDİŞ
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AnimalsScreen(),
                    ),
                  );
                },
              ),
              // 3. BUTON: RENKLER
              _buildManualPositionedButton(
                context,
                title: "Renkler",
                rabbitImg: "assets/mainscreen_asset3.png",
                rightImg: "assets/renkler.png",
                topPadding: 35,
                rabbitHeight: 145,
                rabbitLeft: -13,
                rabbitBottom: 0,
                rightIconHeight: 154,
                rightIconRight: 5,
                rightIconTop: -3,
                onTap: () => print("Renkler yakında!"),
              ),

              // 4. BUTON: SAYILAR
              _buildManualPositionedButton(
                context,
                title: "Sayılar",
                rabbitImg: "assets/mainscreen_asset4.png",
                rightImg: "assets/sayilar.png",
                topPadding: 35,
                rabbitHeight: 146,
                rabbitLeft: 0,
                rabbitBottom: 0,
                rightIconHeight: 150,
                rightIconRight: 15,
                rightIconTop: -4,
                onTap: () => print("Sayılar yakında!"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManualPositionedButton(
    BuildContext context, {
    required String title,
    required String rabbitImg,
    required String rightImg,
    required double topPadding,
    required double rabbitHeight,
    required double rabbitLeft,
    required double rabbitBottom,
    required double rightIconHeight,
    required double rightIconRight,
    required double rightIconTop,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 35, right: 35, top: topPadding),
      child: SizedBox(
        height: 145,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: onTap,
                  child: Ink(
                    height: 145,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(220, 238, 246, 1),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'LexendDeca',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(36, 37, 44, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: rabbitLeft,
              bottom: rabbitBottom,
              child: IgnorePointer(
                child: Image.asset(
                  rabbitImg,
                  height: rabbitHeight,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              right: rightIconRight,
              top: rightIconTop,
              child: IgnorePointer(
                child: Image.asset(
                  rightImg,
                  height: rightIconHeight,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopMenu() {
    return const Padding(
      padding: EdgeInsets.only(top: 14, right: 30),
      child: Align(
        alignment: Alignment.topRight,
        child: ParentPanelHoldButton(),
      ),
    );
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
        
        // EKLENEN KISIM: Ebeveyn paneline geçerken süreyi durduruyoruz ki ebeveynin okuduğu süre çocuğa yazılmasın
        TimeTrackerService.stopTracking();

        // Ebeveyn Rapor Paneline yönlendirir
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ParentDashboardScreen()),
        ).then((_) {
          // EKLENEN KISIM: Ebeveyn panelinden geri dönüldüğünde sayacı tekrar başlatıyoruz
          TimeTrackerService.startTracking();
        });
        
        // Yönlendirme sonrası butonu sıfırla ki kullanıcı geri döndüğünde halka boş gözüksün
        _controller.reset();
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