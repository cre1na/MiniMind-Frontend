import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Ebeveyn rapor ekranının importu (Yolunu kendi projene göre düzeltirsin)
import 'parent_dashboard_screen.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  String childName = "Çocuk"; // Varsayılan isim
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChildProfile();
  }

  // Firebase'den giriş yapan kullanıcının çocuğunun adını çekiyoruz
  Future<void> _fetchChildProfile() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        // Firestore'da 'users' koleksiyonundaki kullanıcı belgesine bakıyoruz.
        // NOT: Veritabanındaki alan adın 'childName' değilse burayı kendi veritabanına göre güncellemelisin.
        final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (doc.exists && doc.data() != null) {
          setState(() {
            childName = doc.data()?['childName'] ?? doc.data()?['name'] ?? "Çocuk";
          });
        }
      }
    } catch (e) {
      print("Çocuk profili çekilirken hata: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Arka planın üst kısmı beyaz/hafif renkli
      backgroundColor: const Color.fromRGBO(250, 252, 246, 1), 
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Üstteki boşluk ve dekoratif alan (Görseldeki gibi üst kısım)
            const SizedBox(height: 100),
            
            // Açık mavi ve yuvarlak köşeli alt panel
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F1F8), // Görseldeki açık mavi ton
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 25.0, right: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Başlık ve Altındaki Pembe Çizgi
                      const Text(
                        'Çocuk Profili Seçin',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 3,
                        width: 170,
                        decoration: BoxDecoration(
                          color: Colors.pink.shade200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Profillerin Listelendiği Grid
                      Expanded(
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: 0.85,
                                mainAxisSpacing: 30,
                                crossAxisSpacing: 30,
                                children: [
                                  // Veritabanından gelen gerçek çocuk profili
                                  _buildProfileCard(
                                    context, 
                                    name: childName, 
                                    initial: childName.isNotEmpty ? childName[0].toUpperCase() : 'Ç',
                                  ),
                                  
                                  // Şimdilik pasif olan Ekle butonu
                                  _buildAddProfileCard(),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, {required String name, required String initial}) {
    return InkWell(
      // Tıklanınca Ebeveyn Rapor Ekranına (Dashboard) gidecek
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ParentDashboardScreen()),
        );
      },
      child: Column(
        children: [
          Container(
            height: 110,
            width: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.pink.shade200, width: 2), // Pembe çerçeve
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  fontSize: 65,
                  color: Color(0xFF1CB0F6), // Görseldeki parlak mavi harf rengi
                  fontWeight: FontWeight.w900,
                  fontFamily: 'LexendDeca', // Kendi fontunuz varsa
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddProfileCard() {
    return Column(
      children: [
        Container(
          height: 110,
          width: 110,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5), // Tıklanamaz olduğunu belli etmek için hafif şeffaf
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.pink.shade100, width: 2),
          ),
          child: Icon(Icons.add, size: 50, color: Colors.black.withOpacity(0.6)),
        ),
        const SizedBox(height: 12),
        const Text(
          'Profil Ekle',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}