import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minimind/screens/profile_create_screen.dart';
// YENİ EKLENEN: Login ekranının importu (Dosya adını projene göre ayarlayabilirsin)
import '../screens/loginscreen.dart'; 
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  //durum - kontrol degiskenleri
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool isCircleSelected = false;

  bool get isFormValid =>
      _nameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _confirmController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  //yardımcı fonk
  Route _createInstantRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  //KAYIT OL FONKSİYONU
  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // 🔴 Şifre kontrolü
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Şifreler eşleşmiyor!")));
      return;
    }

    try {
      // 🔥 Firebase Auth kayıt
      final user = await _authService.register(
        name: name,
        email: email,
        password: password,
      );

      if (user == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Kayıt başarısız")));
        return;
      }

      // 🔥 Firestore'a kullanıcı yaz
      final uid = user;

      if (uid == null) {
        throw Exception("UID bulunamadı");
      }

      await _firestoreService.createUser(uid: uid, name: name, email: email);

      // 🔥 Remember me
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('rememberMe', isCircleSelected);

      // 🔥 Sonraki ekrana geç
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          _createInstantRoute(const ProfileCreateScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 260),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 40,
                ),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(220, 238, 246, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(53),
                    topRight: Radius.circular(53),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.6,
                      offset: Offset(6, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Kayıt Ol",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'LexendDeca',
                          ),
                        ),
                        Container(
                          height: 3,
                          width: 105,
                          color: const Color(0xFFFFB2D9),
                        ),
                        const SizedBox(height: 30),
                        _buildInputLabel("Ad Soyad"),
                        TextFormField(
                          controller: _nameController,
                          decoration: _buildInputDecoration(
                            Icons.badge_outlined,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildInputLabel("E-posta Adresi"),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _buildInputDecoration(
                            Icons.email_outlined,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildInputLabel("Şifre"),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isPasswordObscured,
                          decoration: _buildInputDecoration(
                            Icons.more_horiz,
                            isPassword: true,
                            isObscured: _isPasswordObscured,
                            hint: "Şifreniz en az 6 karakter olmalıdır.",
                            onToggle: () => setState(
                              () => _isPasswordObscured = !_isPasswordObscured,
                            ),
                          ),
                          // Şifre uzunluğu kontrolü
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return "Şifre en az 6 karakter olmalıdır.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildInputLabel("Şifre Onay"),
                        TextFormField(
                          controller: _confirmController,
                          obscureText: _isConfirmPasswordObscured,
                          decoration: _buildInputDecoration(
                            Icons.more_horiz,
                            isPassword: true,
                            isObscured: _isConfirmPasswordObscured,
                            onToggle: () => setState(
                              () => _isConfirmPasswordObscured =
                                  !_isConfirmPasswordObscured,
                            ),
                          ),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return "Girdiğiniz şifreler eşleşmiyor.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(
                                () => isCircleSelected = !isCircleSelected,
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                  color: isCircleSelected
                                      ? const Color(0xFFFFB2D9)
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Beni hatırla",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'LexendDeca',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                if (isFormValid)
                                  const BoxShadow(
                                    color: Color.fromRGBO(255, 114, 187, 1),
                                    spreadRadius: -6,
                                    blurRadius: 30,
                                    offset: Offset(0, 6),
                                  ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: isFormValid
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        _handleRegister();
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isFormValid
                                    ? const Color.fromRGBO(255, 173, 199, 1)
                                    : const Color.fromRGBO(255, 173, 199, 0.4),
                                disabledBackgroundColor: const Color.fromRGBO(
                                  255,
                                  173,
                                  199,
                                  0.4,
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                "Kayıt",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'LexendDeca',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        // DÜZELTİLEN KISIM: Doğrudan LoginScreen'e yönlendiriyor
                        Center(
                          child: TextButton(
                            onPressed: () {
                              // Kayıt ekranını kapatıp Giriş Yap ekranını açar (Ekranda şişme yapmaz)
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            style: TextButton.styleFrom(
                              overlayColor: Colors.pink.withOpacity(0.1),
                            ),
                            child: RichText(
                              text: const TextSpan(
                                text: "Hesabın var mı? ",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontFamily: 'LexendDeca',
                                ),
                                children: [
                                  TextSpan(
                                    text: "Giriş yap",
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 173, 199, 1),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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

  //dec func
  InputDecoration _buildInputDecoration(
    IconData icon, {
    bool isPassword = false,
    bool? isObscured,
    VoidCallback? onToggle,
    String? hint,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 12,
        color: Colors.black.withOpacity(0.6),
        fontFamily: 'LexendDeca',
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      prefixIcon: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 12),
            Icon(icon, color: Colors.black87, size: 20),
            const SizedBox(width: 8),
            Container(
              width: 2,
              height: 15,
              color: const Color.fromRGBO(164, 164, 164, 1),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                isObscured!
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: onToggle,
            )
          : null,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black38),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w300,
              fontFamily: 'LexendDeca',
            ),
          ),
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 173, 199, 1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}