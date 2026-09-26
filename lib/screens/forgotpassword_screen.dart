import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  bool get isEmailValid =>
      _emailController.text.isNotEmpty && _emailController.text.contains('@');

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Şifrenizi Yenileyin",
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

                  const SizedBox(height: 6),

                  const Text(
                    "Hesabınızın kayıtlı olduğu e-posta adresini giriniz.",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'LexendDeca',
                      fontWeight: FontWeight.w300,
                      color: Color.fromRGBO(36, 37, 44, 0.7),
                    ),
                  ),

                  const SizedBox(height: 33),

                  // E-posta Giriş Alanı
                  const Text(
                    "E-posta Adresi",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'LexendDeca',
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: Colors.black87,
                      ),
                      hintText: "minimind@gmail.com",
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: Colors.black26,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Gönder Butonu
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          if (isEmailValid)
                            BoxShadow(
                              color: const Color.fromRGBO(255, 173, 199, 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: isEmailValid
    ? () async {
        final result = await _authService.sendPasswordResetEmail(
          _emailController.text.trim(),
        );

        if (result == null) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Şifre sıfırlama maili gönderildi"),
            ),
          );

          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result)),
          );
        }
      }
    : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                            255,
                            173,
                            199,
                            1,
                          ),
                          disabledBackgroundColor: const Color.fromRGBO(
                            255,
                            173,
                            199,
                            0.4,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 55,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Gönder",
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
