import 'package:flutter/material.dart';
import 'package:minimind/screens/main_screen.dart';

class ProfileCreateScreen extends StatefulWidget {
  const ProfileCreateScreen({super.key});

  @override
  State<ProfileCreateScreen> createState() => _ProfileCreateScreenState();
}

class _ProfileCreateScreenState extends State<ProfileCreateScreen> {
  final TextEditingController _nameController = TextEditingController();
  String selectedAge = "";

  bool get isFormValid =>
      _nameController.text.isNotEmpty && selectedAge.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  //yardımcı fonk
  Route _createInstantRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          child,
    );
  }

  //profil oluşturma
  Future<void> _handleProfileCreate() async {
    //BACKEND

    print("Profil kaydediliyor...");

    if (mounted) {
      //profil seçme ekranından gelen
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      //ilk kayıt kullanıcı (kayıt ekranıdna gelen)
      else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainMenuScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 252, 246, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 150),
            const Text(
              "Çocuk Profili Oluşturun",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                fontFamily: 'LexendDeca',
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Çocuğunuzu temsil eden bir profil oluşturun.",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'LexendDeca',
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 48),

            // İSİM GİRME ALANI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Adı:",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontFamily: 'LexendDeca',
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(239, 244, 255, 0.76),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(255, 119, 163, 1),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(255, 173, 199, 1),
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // YAŞ BUTONLARI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Yaşı:",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontFamily: 'LexendDeca',
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildAgeButton("2 yaş"),
                      _buildAgeButton("3 yaş"),
                      _buildAgeButton("4 yaş"),
                      _buildAgeButton("5 yaş"),
                    ],
                  ),
                ],
              ),
            ),

            // Maskot ve Oluştur Butonu
            SizedBox(
              height: 478,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: -30,
                    child: Image.asset(
                      'assets/MiniProfile.png',
                      width: 340.3,
                      height: 399.4,
                    ),
                  ),
                  Positioned(bottom: 200, right: 40, child: _buildNameButton()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeButton(String ageText) {
    bool isSelected = selectedAge == ageText;
    return GestureDetector(
      onTap: () => setState(() => selectedAge = ageText),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromRGBO(255, 173, 199, 0.76)
              : const Color.fromRGBO(239, 244, 255, 0.76),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color.fromRGBO(255, 173, 199, 1),
            width: 2,
          ),
        ),
        child: Text(
          ageText,
          style: TextStyle(
            fontFamily: 'LexendDeca',
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w300,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildNameButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          if (isFormValid)
            const BoxShadow(
              color: Color.fromRGBO(255, 173, 199, 1),
              spreadRadius: -6,
              blurRadius: 30,
              offset: Offset(0, 6),
            ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isFormValid ? _handleProfileCreate : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid
              ? const Color.fromRGBO(255, 173, 199, 1)
              : const Color.fromRGBO(255, 173, 199, 0.4),
          disabledBackgroundColor: const Color.fromRGBO(255, 173, 199, 0.4),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Text(
          "Oluştur",
          style: TextStyle(
            color: isFormValid ? Colors.white : Colors.white70,
            fontSize: 19,
            fontFamily: 'LexendDeca',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
