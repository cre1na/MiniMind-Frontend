import 'package:flutter/material.dart';

class ForgotPassSuccessScreen extends StatelessWidget {
  const ForgotPassSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Mavi Panel
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(220, 238, 246, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(53),
                  topRight: Radius.circular(53),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    blurRadius: 10.6,
                    offset: Offset(6, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Şifreniz Yenilendi",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'LexendDeca',
                            color: Color.fromRGBO(36, 37, 44, 1),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 3,
                          width: 202,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 173, 199, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Açıklama Metni
                  const Text(
                    "Yeni şifreniz ile giriş yapabilirsiniz.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'LexendDeca',
                      fontWeight: FontWeight.w300,
                      color: Color.fromRGBO(36, 37, 44, 0.7),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ONAY İKONU
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromRGBO(239, 244, 255, 1),
                      border: Border.all(
                        color: const Color.fromRGBO(255, 173, 199, 1),
                        width: 2.5,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        size: 40,
                        color: Color.fromRGBO(255, 173, 199, 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Giriş Butonu
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(255, 173, 199, 0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          //yönlendirme
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                            255,
                            173,
                            199,
                            1,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 45,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Giriş",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'LexendDeca',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
