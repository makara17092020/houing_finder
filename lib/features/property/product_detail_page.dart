import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:houing_finder/features/auth/login_page.dart';
import 'package:houing_finder/features/auth/register_page.dart';
import 'package:houing_finder/features/auth/review_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth_service.dart';
import 'models/property.dart';

class ProductDetailPage extends StatelessWidget {
  final Property property;

  const ProductDetailPage({super.key, required this.property});

  void _showLoginPrompt(BuildContext context, String action) async {
    await showDialog<String?>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Login Required",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Please login or register $action.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(dialogContext); // Close Dialog
                      if (!context.mounted) return;

                      // Wait for result from LoginPage
                      final logged = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const LoginPage(redirectToHome: false),
                        ),
                      );

                      // If login was successful, auto-link to review page
                      if (logged == true && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ReviewPage()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: const Color(0xFF1E3A8A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(dialogContext); // Close Dialog
                      if (!context.mounted) return;

                      // Wait for result from RegisterPage
                      final registered = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const RegisterPage(redirectToHome: false),
                        ),
                      );

                      // If registration was successful, auto-link to review page
                      if (registered == true && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ReviewPage()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Register",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              property.imageUrl,
              height: 380,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF1E3A8A),
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        property.location,
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "\$${property.price}/month",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildSpec(
                        Icons.king_bed_outlined,
                        "${property.beds} Bedroom",
                      ),
                      const SizedBox(width: 32),
                      _buildSpec(
                        Icons.bathtub_outlined,
                        "${property.baths} Bathroom",
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Amenities",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildAmenityChip(Icons.wifi, "WiFi"),
                      _buildAmenityChip(Icons.pool, "Pool"),
                      _buildAmenityChip(Icons.ac_unit, "Air Conditioning"),
                      _buildAmenityChip(Icons.local_parking, "Parking"),
                      _buildAmenityChip(Icons.security, "24/7 Security"),
                      _buildAmenityChip(Icons.fitness_center, "Gym"),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Agent Details",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 32,
                              backgroundImage: NetworkImage(
                                'https://picsum.photos/id/1062/100/100',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sophie Lin",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        "Real Estate Agent",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.verified,
                                        color: Color(0xFF1E3A8A),
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Usually responds within 1 hour",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildContactRow(
                          Icons.phone,
                          "Phone number: +855 123 456 789",
                          'tel:+855123456789',
                          "Call",
                        ),
                        const SizedBox(height: 16),
                        _buildContactRow(
                          Icons.telegram,
                          "Telegram: @sophie_lin_agent",
                          'https://t.me/sophie_lin_agent',
                          "Message",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      if (AuthService.isLoggedIn) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ReviewPage()),
                        );
                      } else {
                        _showLoginPrompt(context, "to see reviews");
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 34,
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${property.rating} • Excellent",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "124 reviews",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                "Rate Our Property",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1E3A8A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildRatingBar(5, 0.68),
                          _buildRatingBar(4, 0.21),
                          _buildRatingBar(3, 0.06),
                          _buildRatingBar(2, 0.02),
                          _buildRatingBar(1, 0.01),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Description",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Beautiful modern apartment in the heart of Toul Kork. Walking distance to schools, AEON Mall, and many restaurants. Fully furnished with high-speed internet and 24/7 security.",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(
    IconData icon,
    String label,
    String urlString,
    String btnText,
  ) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1E3A8A), size: 24),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: GoogleFonts.poppins(fontSize: 16))),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF34D399)],
            ),
          ),
          child: ElevatedButton(
            onPressed: () async {
              final Uri url = Uri.parse(urlString);
              if (await canLaunchUrl(url)) await launchUrl(url);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(btnText),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBar(int stars, double progress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            "$stars",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF1E3A8A),
                ),
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpec(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1E3A8A), size: 28),
        const SizedBox(width: 10),
        Text(text, style: GoogleFonts.poppins(fontSize: 17)),
      ],
    );
  }

  Widget _buildAmenityChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF1E3A8A), size: 20),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.poppins(fontSize: 14)),
        ],
      ),
    );
  }
}
