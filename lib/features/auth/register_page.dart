import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/auth_service.dart';

import '../home/home_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  /// If true the page pushes replacement to [HomePage] after registration.
  /// Set to false when you want the caller to handle post-signup actions.
  const RegisterPage({super.key, this.redirectToHome = true});

  final bool redirectToHome;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.22),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    fullNameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call
    setState(() => _isLoading = false);

    // mark authenticated
    AuthService.isLoggedIn = true;

    if (!mounted) return;
    if (widget.redirectToHome) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      Navigator.pop(context, true);
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        pageBuilder: (context, animation, secondaryAnimation) =>
            LoginPage(redirectToHome: widget.redirectToHome),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(-0.12, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F5F0), Color(0xFFFCFAF7)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 48),

                // Elegant header with Hero logo
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        Hero(
                          tag: 'app_logo',
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 25,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.home_rounded,
                              size: 72,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          "Create your account",
                          style: GoogleFonts.poppins(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111827),
                            height: 1.05,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Join thousands finding their dream home",
                          style: GoogleFonts.poppins(
                            fontSize: 16.5,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 52),

                // Premium card
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            blurRadius: 50,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Full Name
                            _buildInputField(
                              controller: fullNameController,
                              hint: "Full name",
                              icon: Icons.person_outline,
                              validator: (v) => v!.trim().isEmpty
                                  ? "Full name is required"
                                  : null,
                            ),
                            const SizedBox(height: 20),

                            // Username
                            _buildInputField(
                              controller: usernameController,
                              hint: "Username",
                              icon: Icons.alternate_email,
                              validator: (v) => v!.trim().isEmpty
                                  ? "Username is required"
                                  : null,
                            ),
                            const SizedBox(height: 20),

                            // Phone
                            _buildInputField(
                              controller: phoneController,
                              hint: "Phone number",
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (v) => (v == null || v.length < 10)
                                  ? "Enter a valid phone number"
                                  : null,
                            ),
                            const SizedBox(height: 20),

                            // Email
                            _buildInputField(
                              controller: emailController,
                              hint: "Email address",
                              icon: Icons.email_outlined,
                              validator: (v) =>
                                  (v == null ||
                                      !v.contains('@') ||
                                      !v.contains('.'))
                                  ? "Enter a valid email"
                                  : null,
                            ),
                            const SizedBox(height: 20),

                            // Password
                            _buildInputField(
                              controller: passwordController,
                              hint: "Password",
                              icon: Icons.lock_outline_rounded,
                              obscureText: _obscurePassword,
                              validator: (v) => (v == null || v.length < 6)
                                  ? "Password must be 6+ characters"
                                  : null,
                              suffix: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Premium gradient button
                            _buildRegisterButton(),

                            const SizedBox(height: 40),

                            // Sign in link with Hero
                            GestureDetector(
                              onTap: _navigateToLogin,
                              child: Hero(
                                tag: 'signin_link',
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.poppins(
                                      fontSize: 15.5,
                                      color: Colors.grey[700],
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: "Already have an account? ",
                                      ),
                                      TextSpan(
                                        text: "Sign in",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1E3A8A),
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
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: 15.5),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 15.5),
        prefixIcon: Icon(icon, color: Colors.grey[400], size: 22),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 22,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 1.8),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E3A8A).withValues(alpha: 0.3),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: _isLoading ? null : _register,
            splashColor: Colors.white.withOpacity(0.2),
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.8,
                      ),
                    )
                  : Text(
                      "Create account",
                      style: GoogleFonts.poppins(
                        fontSize: 17.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.4,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
