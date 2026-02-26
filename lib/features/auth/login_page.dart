import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/auth_service.dart';

import '../home/home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  /// If true the page will replace itself with [HomePage] after successful
  /// authentication.  When launching from another page that needs to react to
  /// the login (for example the product detail view) pass `redirectToHome: false`.
  const LoginPage({super.key, this.redirectToHome = true});

  final bool redirectToHome;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate API
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
      // SUCCESS: Returning 'true' tells the calling page (Product Detail)
      // that login was successful, so it can auto-navigate to the Review page.
      Navigator.pop(context, true);
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        pageBuilder: (_, _, _) =>
            RegisterPage(redirectToHome: widget.redirectToHome),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.12, 0),
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

  void _handleForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Forgot password coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider sign-in coming soon'),
        behavior: SnackBarBehavior.floating,
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

                // Header
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
                          "Welcome back",
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
                          "Sign in to find your perfect home",
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

                // Premium Card
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
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _handleForgotPassword,
                                child: Text(
                                  "Forgot password?",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildLoginButton(),
                            const SizedBox(height: 32),
                            _buildOrDivider(),
                            const SizedBox(height: 32),

                            // Social Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildSocialButton(
                                  FontAwesomeIcons.google,
                                  const Color(0xFFDB4437),
                                  () => _handleSocialLogin("Google"),
                                ),
                                const SizedBox(width: 24),
                                _buildSocialButton(
                                  FontAwesomeIcons.apple,
                                  Colors.black,
                                  () => _handleSocialLogin("Apple"),
                                  34,
                                ),
                                const SizedBox(width: 24),
                                _buildSocialButton(
                                  FontAwesomeIcons.facebook,
                                  const Color(0xFF1877F2),
                                  () => _handleSocialLogin("Facebook"),
                                ),
                              ],
                            ),

                            const SizedBox(height: 40),

                            GestureDetector(
                              onTap: _navigateToRegister,
                              child: Hero(
                                tag: 'signup_link',
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.poppins(
                                      fontSize: 15.5,
                                      color: Colors.grey[700],
                                    ),
                                    children: const [
                                      TextSpan(text: "Don’t have an account? "),
                                      TextSpan(
                                        text: "Sign up",
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

  // Input Field remains identical in style
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 1.8),
        ),
      ),
    );
  }

  // Login Button remains identical in style
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
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
            onTap: _isLoading ? null : _login,
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
                      "Sign in",
                      style: GoogleFonts.poppins(
                        fontSize: 17.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1.2)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "OR",
            style: GoogleFonts.poppins(
              color: Colors.grey[500],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1.2)),
      ],
    );
  }

  Widget _buildSocialButton(
    IconData icon,
    Color color,
    VoidCallback onTap, [
    double size = 28,
  ]) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: FaIcon(icon, color: Colors.white, size: size),
        ),
      ),
    );
  }
}
