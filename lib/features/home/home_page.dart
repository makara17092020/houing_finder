// lib/features/home/home_page.dart
// PREMIUM LUXURY HOUSING FINDER HOMEPAGE - SEARCH BAR MOVED DOWN
// ✅ Massive animated green gradient hero header
// ✅ Search bar now cleanly positioned BELOW the header (as requested)
// ✅ All other premium features preserved (glassmorphism, animations, staggered cards, etc.)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/auth_service.dart';
import '../auth/login_page.dart';
import '../profile/profile_page.dart';
import '../property/models/property.dart';
import '../property/product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _selectedPrice = '200';

  late final AnimationController _pageController;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _searchScale;

  final List<Property> _allProperties = [
    Property(
      id: '1',
      title: 'Modern Apartment in Toul Kork',
      location: 'Toul Kork, Phnom Penh',
      imageUrl: 'https://picsum.photos/id/1015/800/600',
      price: 120,
      rating: 4.8,
      beds: 1,
      baths: 1,
      isAvailable: true,
    ),
    Property(
      id: '2',
      title: 'Luxury Villa near Russian Market',
      location: 'BKK1, Phnom Penh',
      imageUrl: 'https://picsum.photos/id/133/800/600',
      price: 450,
      rating: 4.9,
      beds: 3,
      baths: 2,
      isAvailable: true,
    ),
    Property(
      id: '3',
      title: 'Cozy Studio near AEON Mall',
      location: 'Sen Sok, Phnom Penh',
      imageUrl: 'https://picsum.photos/id/201/800/600',
      price: 85,
      rating: 4.6,
      beds: 1,
      baths: 1,
      isAvailable: false,
    ),
    Property(
      id: '4',
      title: 'Family House in Borey',
      location: 'Chroy Changvar, Phnom Penh',
      imageUrl: 'https://picsum.photos/id/251/800/600',
      price: 320,
      rating: 4.7,
      beds: 4,
      baths: 3,
      isAvailable: true,
    ),
  ];

  List<Property> get _filteredProperties {
    return _allProperties.where((p) {
      final matchesSearch =
          p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.location.toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesFilter = true;
      if (_selectedFilter != 'All') {
        matchesFilter =
            (_selectedFilter == 'Near School' &&
                p.location.contains('Toul Kork')) ||
            (_selectedFilter == 'Available' && p.isAvailable);
      }
      final matchesPrice = p.price < int.parse(_selectedPrice);
      return matchesSearch && matchesFilter && matchesPrice;
    }).toList();
  }

  void _goToProfile() {
    final isLoggedIn = AuthService.isLoggedIn;
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1450),
    );

    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pageController, curve: Curves.easeOutCubic),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _pageController, curve: Curves.easeOutCubic),
        );

    _searchScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pageController, curve: Curves.elasticOut),
    );

    _pageController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFECFDF5)],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // === LUXURY GREEN GRADIENT HERO HEADER ===
            SliverAppBar(
              expandedHeight: 260,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: ClipPath(
                  clipper: _HeaderCurveClipper(),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF047857),
                          Color(0xFF10B981),
                          Color(0xFF34D399),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Stack(
                        children: [
                          Positioned(
                            top: 40,
                            right: -30,
                            child: Opacity(
                              opacity: 0.12,
                              child: Icon(
                                Icons.home_work_rounded,
                                size: 180,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FadeTransition(
                                      opacity: _headerFade,
                                      child: SlideTransition(
                                        position: _headerSlide,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Good morning,",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.white.withOpacity(
                                                  0.85,
                                                ),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "Phnom Penh",
                                              style: GoogleFonts.poppins(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                height: 1.05,
                                                letterSpacing: -1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _goToProfile,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFFFFFFF),
                                              Color(0xFF34D399),
                                            ],
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 26,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 24,
                                            backgroundColor: const Color(
                                              0xFF10B981,
                                            ),
                                            child: const Icon(
                                              Icons.person_rounded,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                FadeTransition(
                                  opacity: _headerFade,
                                  child: Text(
                                    "Housing Finder",
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: -0.8,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Discover premium homes in Cambodia",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 50),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // === SEARCH BAR NOW POSITIONED DOWN (BELOW HEADER) ===
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  0,
                ), // Clean spacing below header
                child: ScaleTransition(
                  scale: _searchScale,
                  child: Container(
                    height: 66,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.7)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      style: GoogleFonts.poppins(fontSize: 17),
                      decoration: InputDecoration(
                        hintText: "Search homes in Phnom Penh...",
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey[500],
                          fontSize: 16.5,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF10B981),
                          size: 28,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === ANIMATED FILTER CHIPS ===
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...['All', 'Near School', 'Available'].map(
                            (filter) => Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: _buildAnimatedFilterChip(filter),
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildGlassPriceSelector(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    FadeTransition(
                      opacity: _headerFade,
                      child: Text(
                        "Featured Homes in Phnom Penh",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // === STAGGERED LUXURY PROPERTY CARDS ===
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredProperties.length,
                      itemBuilder: (context, index) {
                        final property = _filteredProperties[index];
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 600 + (index * 120)),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 40 * (1 - value)),
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailPage(property: property),
                              ),
                            ),
                            child: _buildPremiumPropertyCard(property, index),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 140),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // All other methods remain exactly the same (filter chips, price selector, property cards, etc.)
  Widget _buildAnimatedFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 220),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF34D399)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey.shade200,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Text(
            filter,
            style: GoogleFonts.poppins(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF374151),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassPriceSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: _selectedPrice,
        underline: const SizedBox(),
        icon: const Icon(
          Icons.arrow_drop_down_rounded,
          color: Color(0xFF10B981),
        ),
        style: GoogleFonts.poppins(
          fontSize: 15.5,
          color: const Color(0xFF1F2937),
          fontWeight: FontWeight.w600,
        ),
        onChanged: (v) => setState(() => _selectedPrice = v!),
        items: ['100', '200', '300', '400', '500', '600', '700', '800']
            .map((v) => DropdownMenuItem(value: v, child: Text('Under \$$v')))
            .toList(),
      ),
    );
  }

  Widget _buildPremiumPropertyCard(Property property, int index) {
    return Hero(
      tag: 'property-${property.id}',
      child: Container(
        margin: const EdgeInsets.only(bottom: 28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.11),
              blurRadius: 35,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Column(
            children: [
              Stack(
                children: [
                  Image.network(
                    property.imageUrl,
                    height: 255,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 90,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black26, Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 18,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border_rounded,
                        color: const Color(0xFFE11D48),
                        size: 26,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 18,
                    left: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF34D399)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "\$${property.price}/mo",
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(24),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.title,
                      style: GoogleFonts.poppins(
                        fontSize: 20.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Color(0xFF10B981),
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            property.location,
                            style: GoogleFonts.poppins(
                              fontSize: 15.5,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildSpec(
                          Icons.king_bed_outlined,
                          "${property.beds} Beds",
                        ),
                        const SizedBox(width: 32),
                        _buildSpec(
                          Icons.bathtub_outlined,
                          "${property.baths} Baths",
                        ),
                        const Spacer(),
                        if (property.isAvailable)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              "Available Now",
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 24,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          property.rating.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "View Details →",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpec(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF10B981), size: 22),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 15.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Custom curved header clipper (unchanged)
class _HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height + 25,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
