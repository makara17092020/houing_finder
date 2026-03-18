// lib/features/profile/profile_page.dart
// Premium Modern Profile Page - SIMPLIFIED as requested
// ✅ Clean circular avatar + name/username directly below (no big box)
// ✅ Simple but clean Favorites section

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pageController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _avatarScale;
  late final Animation<double> _statsScale;

  int _selectedTab = 3;

  @override
  void initState() {
    super.initState();
    _pageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pageController, curve: Curves.easeOutCubic),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(parent: _pageController, curve: Curves.easeOutCubic),
        );

    _avatarScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pageController, curve: Curves.elasticOut),
    );

    _statsScale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _pageController, curve: Curves.easeOutBack),
    );

    _pageController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildGradientAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFECFDF5)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
            child: Column(
              children: [
                // === SIMPLIFIED PROFILE HEADER ===
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        // Clean circular avatar with thin gradient ring
                        ScaleTransition(
                          scale: _avatarScale,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF34D399)],
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 72,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 67,
                                backgroundImage: const NetworkImage(
                                  'https://picsum.photos/id/64/400/400', // ← Replace with your image
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Name & Username directly under avatar
                        Text(
                          'Someone',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          '@someone',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Action buttons (premium gradient)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildActionButtons(),
                  ),
                ),

                const SizedBox(height: 40),

                // === SIMPLE & CLEAN FAVORITES SECTION ===
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _statsScale,
                    child: _buildSimpleFavoritesCard(),
                  ),
                ),

                const SizedBox(height: 40),

                // Personal Info (kept premium glass style)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Info',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildInfoGlassTile(
                          Icons.person_outline_rounded,
                          'Fullname',
                          'Someone',
                        ),
                        _buildInfoGlassTile(
                          Icons.alternate_email_rounded,
                          'Username',
                          '@someone',
                        ),
                        _buildInfoGlassTile(
                          Icons.email_outlined,
                          'Email',
                          'Someone@gmail.com',
                        ),
                        _buildInfoGlassTile(
                          Icons.phone_outlined,
                          'Phone',
                          '+00 000 000',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Glass bottom nav (unchanged - still premium)
      bottomNavigationBar: _buildGlassBottomNav(size),
    );
  }

  PreferredSizeWidget _buildGradientAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF047857)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildPremiumButton(
            label: 'Edit Profile',
            icon: Icons.edit_outlined,
            isPrimary: true,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildPremiumButton(
            label: 'Logout',
            icon: Icons.logout_rounded,
            isPrimary: false,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF34D399)],
                )
              : null,
          color: isPrimary ? null : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
          border: isPrimary
              ? null
              : Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.3),
                  width: 1.5,
                ),
          boxShadow: [
            BoxShadow(
              color: isPrimary
                  ? const Color(0xFF10B981).withOpacity(0.3)
                  : Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary ? Colors.white : const Color(0xFF10B981),
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isPrimary ? Colors.white : const Color(0xFF10B981),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Simple & Clean Favorites Card
  Widget _buildSimpleFavoritesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.favorite_rounded,
            size: 42,
            color: Color(0xFF10B981),
          ),
          const SizedBox(height: 12),
          Text(
            '0',
            style: GoogleFonts.poppins(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
            ),
          ),
          Text(
            'Favorites',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGlassTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFF10B981), size: 26),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassBottomNav(Size size) {
    const double itemWidth = 60;
    final double indicatorLeft = 24 + (_selectedTab * (size.width - 48) / 4);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      height: 78,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 40,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeOutCubic,
            left: indicatorLeft,
            top: 8,
            child: Container(
              width: itemWidth,
              height: 62,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF34D399)],
                ),
                borderRadius: BorderRadius.circular(26),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(0, Icons.home_rounded, 'Home'),
                _navItem(1, Icons.search_rounded, 'Search'),
                _navItem(2, Icons.favorite_rounded, 'Favorites'),
                _navItem(3, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: isSelected ? 1.25 : 1.0,
            duration: const Duration(milliseconds: 280),
            child: Icon(
              icon,
              size: 28,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          AnimatedOpacity(
            opacity: isSelected ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
