import 'package:flutter/material.dart';
import 'package:minimind/screens/signinscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'forgotpassword_screen.dart';
import 'loading.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isPasswordObscured = true;
  bool isCircleSelected = false;

  bool get isFormValid =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final result = await _authService.login(email: email, password: password);

      if (result != null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result)));
        }
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      if (isCircleSelected) {
        await prefs.setBool('isLoggedIn', true);
      }

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          _createInstantRoute(const LoadingScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Giriş hatası: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Klavye açıldığında tasarımın bozulmaması için kritik ayar
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        // Ekranın kaydırılabilir olması taşma hatalarını (22px overflow) çözer
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                // Üst boşluğu ekran boyutuna göre dinamik yapıyoruz
                const Spacer(flex: 2),
                Container(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Giriş Yap",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'LexendDeca',
                        ),
                      ),
                      Container(
                        height: 3,
                        width: 105,
                        color: const Color.fromRGBO(255, 178, 217, 1),
                      ),
                      const SizedBox(height: 40),
                      _buildInputLabel("E-posta Adresi"),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildInputDecoration(Icons.email_outlined),
                      ),
                      const SizedBox(height: 30),
                      _buildInputLabel("Şifre"),
                      TextField(
                        controller: _passwordController,
                        obscureText: _isPasswordObscured,
                        decoration: _buildInputDecoration(Icons.password)
                            .copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordObscured
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () => setState(
                                  () => _isPasswordObscured =
                                      !_isPasswordObscured,
                                ),
                              ),
                            ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                      width: 2,
                                    ),
                                    color: isCircleSelected
                                        ? const Color.fromRGBO(255, 173, 199, 1)
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
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              _createInstantRoute(const ForgotPasswordScreen()),
                            ),
                            child: const Text(
                              "Şifremi Unuttum",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'LexendDeca',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "Hesabınız yok mu? ",
                                style: const TextStyle(
                                  color: Color.fromRGBO(36, 37, 44, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'LexendDeca',
                                ),
                                children: [
                                  TextSpan(
                                    text: "Kayıt ol",
                                    style: const TextStyle(
                                      color: Color.fromRGBO(255, 173, 199, 1),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'LexendDeca',
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.push(
                                        context,
                                        _createInstantRoute(
                                          const SigninScreen(),
                                        ),
                                      ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildLoginButton(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Kod tekrarını önlemek için yardımcı widget'lar
  InputDecoration _buildInputDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: SizedBox(
        width: 55,
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(icon, color: Colors.black87, size: 18),
            const SizedBox(width: 8),
            Container(width: 2, height: 15, color: Colors.black12),
          ],
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black38),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (isFormValid)
            const BoxShadow(
              color: Color.fromRGBO(255, 114, 187, 0.3),
              blurRadius: 20,
              offset: Offset(0, 5),
            ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isFormValid ? _handleLogin : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(255, 173, 199, 1),
          disabledBackgroundColor: const Color.fromRGBO(255, 173, 199, 0.4),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
