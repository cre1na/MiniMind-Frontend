import 'package:flutter/material.dart';
import 'package:minimind/screens/signinscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //arkaplan katmanı
          Positioned.fill(
            child: Image.asset('assets/background.png', fit: BoxFit.cover),
          ),

          //maskot gölgesi
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 400, right: 20),
              child: Container(
                width: 110,
                height: 30,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(100, 144, 189, 0),
                  borderRadius: BorderRadius.all(Radius.elliptical(110, 30)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(100, 144, 189, 0.72),
                      spreadRadius: 6,
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          //maskot katmanı
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 43, left: 30),
              child: Image.asset('assets/mini_onboarding3.png'),
            ),
          ),

          //panel katmanı
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Başlık
                  const Text(
                    "Akıllı Raporlama!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'LexendDeca',
                    ),
                  ),
                  // Alt Metin
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Raporlama sistemi ile çocuğunuzun gelişimini takip edin.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'LexendDeca',
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(110, 106, 124, 1),
                      ),
                    ),
                  ),

                  //devam butonu
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        const BoxShadow(
                          color: Color.fromRGBO(255, 114, 187, 1),
                          spreadRadius: -6,
                          blurRadius: 30,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        //yeni kullanıcı değil bildirimi
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isFirstTime', false);

                        print("Onboarding tamamlandı, hafıza güncellendi.");

                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const SigninScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) => child,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(255, 173, 199, 1),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Devam",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontFamily: 'LexendDeca',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // indikatör
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 7,
                        backgroundColor: Color.fromRGBO(255, 173, 199, 1),
                      ),
                      const SizedBox(width: 35),
                      const CircleAvatar(
                        radius: 7,
                        backgroundColor: Color.fromRGBO(255, 173, 199, 1),
                      ),
                      const SizedBox(width: 35),
                      Container(
                        width: 27,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(251, 145, 179, 1),
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
