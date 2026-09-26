import 'package:flutter/material.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  // Bu liste ileride Database veya API'den gelecek veriyi temsil eder.
  final List<String> profiles = ["Can", "Cansu", "Su"];

  @override
  Widget build(BuildContext context) {
    final double panelHeight = MediaQuery.of(context).size.height * 0.758;

    return Scaffold(
      body: Stack(
        children: [
          //arkaplan resmi
          Positioned.fill(
            child: Image.asset("assets/background.png", fit: BoxFit.cover),
          ),

          //panel katmanı
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: panelHeight,
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
                    blurRadius: 10.6,
                    offset: Offset(6, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Başlık ve Pembe Alt Çizgi
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 55),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Çocuk Profili Seçin",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'LexendDeca',
                            color: Color.fromRGBO(36, 37, 44, 1),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 3,
                          width: 223,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 173, 199, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 75),

                  //butonlar alanı
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Wrap(
                      spacing: 57, //yatay
                      runSpacing: 77, //dikey
                      children: [
                        //otomatik profil oluşturma
                        ...profiles
                            .map((name) => _buildProfileButton(name))
                            .toList(),

                        if (profiles.length < 4)
                          Padding(
                            padding: const EdgeInsets.only(left: 30, top: 30),
                            child: _buildAddButton(),
                          ),
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

  //profil butonu fonksiyonu
  Widget _buildProfileButton(String name) {
    return Column(
      children: [
        Material(
          color: const Color.fromRGBO(239, 244, 255, 0.76),
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            onTap: () => print("$name seçildi"),
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 133,
              height: 129,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color.fromRGBO(255, 173, 199, 1),
                  width: 2,
                ),
              ),
              child: Text(
                name[0].toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 128,
                  height: 0.3,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(12, 180, 255, 1),
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          name,
          style: const TextStyle(
            fontFamily: 'LexendDeca',
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  //profil ekle butonu fonksiyonu
  Widget _buildAddButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: const Color.fromRGBO(239, 244, 255, 0.76),
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            onTap:
                () => print("Yeni profil ekleme ekranına git"), //TEKRAR BAK!!!
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 59,
              height: 57.3,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color.fromRGBO(255, 173, 199, 1),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  size: 31,
                  color: Color.fromRGBO(36, 37, 44, 1),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          "Profil Ekle",
          style: TextStyle(
            fontFamily: 'LexendDeca',
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Color.fromRGBO(36, 37, 44, 1),
          ),
        ),
      ],
    );
  }
}
