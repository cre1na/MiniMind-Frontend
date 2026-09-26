import 'package:flutter/material.dart';
import 'package:minimind/screens/3.onboarding_screen.dart';
import 'package:minimind/screens/signinscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //arkaplan katmanı
          Positioned.fill(
            child: Image.asset('assets/background.png', fit: BoxFit.cover),
          ),

          //görsel katmanı
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 10),
              child: Image.asset('assets/onboarding2_asset.png'),
            ),
          ),

          //atla butonu
          Positioned(
            top: 25,
            right: 12,
            child: SafeArea(
              child: GestureDetector(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();

                  await prefs.setBool('isFirstTime', false);
                  print("yeni kullanıcı degil.");

                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              const SigninScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    "Atla",
                    style: TextStyle(
                      fontFamily: 'LexendDeca',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(36, 37, 44, 1),
                    ),
                  ),
                ),
              ),
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
                    "Öğrenirken Eğlen!",
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
                      "Temel kavramları Mini ile eğlenerek öğrenecek.\nMini her adımında yanında olacak!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'LexendDeca',
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(110, 106, 124, 1),
                      ),
                    ),
                  ),
                  // devam butonu
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(255, 114, 187, 1),
                          spreadRadius: -6,
                          blurRadius: 30,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const OnboardingScreen3(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) {
                              return child;
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(255, 173, 199, 1),
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
                      Container(
                        width: 27,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(251, 145, 179, 1),
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      const SizedBox(width: 35),
                      const CircleAvatar(
                        radius: 7,
                        backgroundColor: Color.fromRGBO(255, 173, 199, 1),
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
