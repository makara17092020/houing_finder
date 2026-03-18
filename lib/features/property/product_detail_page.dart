import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/auth_service.dart';
import '../auth/login_page.dart';
import '../auth/register_page.dart';
import '../auth/review_page.dart';
import '../../models/property.dart';

class ProductDetailPage extends StatelessWidget {
  final Property property;

  const ProductDetailPage({super.key, required this.property});

  // ── Login prompt (unchanged logic) ────────────────────────────────────────
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
                    color: const Color(0xFF111827)),
              ),
              const SizedBox(height: 12),
              Text(
                "Please login or register $action.",
                style:
                GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text("Cancel",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      if (!context.mounted) return;
                      final logged = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                            const LoginPage(redirectToHome: false)),
                      );
                      if (logged == true && context.mounted) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const ReviewPage()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      backgroundColor: const Color(0xFF1E3A8A),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text("Login",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      if (!context.mounted) return;
                      final registered = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                            const RegisterPage(redirectToHome: false)),
                      );
                      if (registered == true && context.mounted) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const ReviewPage()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      backgroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text("Register",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
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
    // ── Not-Found guard ──────────────────────────────────────────────────────
    // If title is empty or id is '0'/'', treat as not found.
    final bool notFound = property.title.trim().isEmpty;
    if (notFound) return _buildNotFoundPage(context);

    // ── Normal detail page ───────────────────────────────────────────────────
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
            // ── Hero image ──────────────────────────────────────────────
            Image.network(
              property.imageUrl,
              height: 380,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 380,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported_rounded,
                    size: 60, color: Colors.grey),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title & location ──────────────────────────────────
                  Text(
                    property.title,
                    style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Color(0xFF10B981), size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          property.location,
                          style: GoogleFonts.poppins(
                              fontSize: 17, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),

                  // ── Category chip ─────────────────────────────────────
                  if (property.category.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        property.category.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF047857),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // ── Price ─────────────────────────────────────────────
                  Text(
                    "\$${property.price.toStringAsFixed(0)}/month",
                    style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E3A8A)),
                  ),

                  // ── Utility costs ─────────────────────────────────────
                  if (property.electricityCost > 0 ||
                      property.waterCost > 0) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (property.electricityCost > 0)
                          _buildUtilityBadge(
                            Icons.bolt_rounded,
                            "\$${property.electricityCost.toStringAsFixed(0)}/kWh",
                            const Color(0xFFF59E0B),
                          ),
                        if (property.electricityCost > 0 &&
                            property.waterCost > 0)
                          const SizedBox(width: 10),
                        if (property.waterCost > 0)
                          _buildUtilityBadge(
                            Icons.water_drop_rounded,
                            "\$${property.waterCost.toStringAsFixed(0)}/m³",
                            const Color(0xFF3B82F6),
                          ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),

                  // ── Beds / Baths ──────────────────────────────────────
                  Row(
                    children: [
                      _buildSpec(
                          Icons.king_bed_outlined, "${property.beds} Bedroom"),
                      const SizedBox(width: 32),
                      _buildSpec(Icons.bathtub_outlined,
                          "${property.baths} Bathroom"),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // ── Description ───────────────────────────────────────
                  if (property.description.isNotEmpty) ...[
                    _buildSectionTitle("Description"),
                    const SizedBox(height: 12),
                    Text(
                      property.description,
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 40),
                  ],

                  // ── Availability banner ───────────────────────────────
                  _buildAvailabilityBanner(),
                  const SizedBox(height: 40),

                  // ── Agent Details ─────────────────────────────────────
                  if (property.agentName.isNotEmpty) ...[
                    _buildSectionTitle("Agent Details"),
                    const SizedBox(height: 16),
                    _buildAgentCard(),
                    const SizedBox(height: 40),
                  ],

                  // ── Reviews section ───────────────────────────────────
                  _buildSectionTitle("Reviews"),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      if (AuthService.isLoggedIn) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ReviewPage()));
                      } else {
                        _showLoginPrompt(context, "to see reviews");
                      }
                    },
                    child: _buildReviewCard(),
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

  // ── Not-found page ──────────────────────────────────────────────────────────
  Widget _buildNotFoundPage(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF047857)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.home_work_outlined,
                  size: 60,
                  color: Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Property Not Found",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "This property may have been removed\nor is no longer available.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                label: Text("Go Back", style: GoogleFonts.poppins(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 36, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Section helpers ─────────────────────────────────────────────────────────

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildAvailabilityBanner() {
    final available = property.isAvailable;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: available
            ? const Color(0xFF10B981).withOpacity(0.1)
            : Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: available
              ? const Color(0xFF10B981).withOpacity(0.3)
              : Colors.red.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            available ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: available ? const Color(0xFF10B981) : Colors.red[400],
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            available ? "Available for Rent" : "Currently Unavailable",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: available ? const Color(0xFF047857) : Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentCard() {
    final hasProfileImage = property.agentProfile != null &&
        property.agentProfile!.isNotEmpty;

    return Container(
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
      child: Row(
        children: [
          // Agent avatar
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFF10B981).withOpacity(0.15),
            backgroundImage: hasProfileImage
                ? NetworkImage(property.agentProfile!)
                : null,
            child: !hasProfileImage
                ? Text(
              property.agentName.isNotEmpty
                  ? property.agentName[0].toUpperCase()
                  : '?',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF047857),
              ),
            )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.agentName,
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      "@${property.agentUsername}",
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.grey[500]),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.verified,
                        color: Color(0xFF1E3A8A), size: 16),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Usually responds within 1 hour",
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard() {
    return Container(
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
              const Icon(Icons.star_rounded, color: Colors.amber, size: 34),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${property.rating.toStringAsFixed(1)} • Excellent",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "Tap to rate this property",
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Rate Now →",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E3A8A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildRatingBar(5, 0.68),
          _buildRatingBar(4, 0.21),
          _buildRatingBar(3, 0.06),
          _buildRatingBar(2, 0.02),
          _buildRatingBar(1, 0.01),
        ],
      ),
    );
  }

  // ── Small UI pieces ─────────────────────────────────────────────────────────

  Widget _buildUtilityBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, double progress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text("$stars",
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF1E3A8A)),
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
}