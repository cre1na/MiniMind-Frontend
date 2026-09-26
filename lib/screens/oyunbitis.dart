import 'package:flutter/material.dart';

// Artık rapor sayfasına yönlendirme yapmayacağımız için o import'u sildik.

class OyunBitis extends StatelessWidget {
  final String oynananOyun; // Hangi oyunun bittiğini tutmaya devam ediyoruz (İleride loglamak vs istersen diye)

  const OyunBitis({super.key, required this.oynananOyun});

  @override
  Widget build(BuildContext context) {
    // Oyun bittikten 3 saniye sonra otomatik olarak Ana Menüye geri döndürür
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        // popUntil ile açık olan tüm oyun pencerelerini kapatıp en baştaki ana menüye dönüyoruz
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });

    return Scaffold(
      backgroundColor: const Color.fromRGBO(195, 184, 160, 1),
      body: GestureDetector(
        // Çocuğun 3 saniye beklemek istemeyip ekrana tıklayarak da menüye dönebilmesi için
        onTap: () {
          if (context.mounted) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        child: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/oyunbitis.png"),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
      ),
    );
  }
}