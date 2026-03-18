import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../core/auth_service.dart';
import '../features/auth/login_page.dart';
import '../features/profile/profile_page.dart';
import '../models/property.dart';
import '../features/property/product_detail_page.dart';
import '../widgets/property_card.dart'; // ← extracted card

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

  // FIX: default to '9999' so ALL properties pass the price filter on first load.
  // Previously '200' silently hid every property priced ≥ $200.
  String _selectedPrice = '9999';

  late final AnimationController _pageController;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _searchScale;

  // ── API state ─────────────────────────────────────────────────────────────
  List<Property> _allProperties = [];
  bool _isLoading = true;
  String? _errorMessage;

  static const String _apiUrl =
      'https://propertyrentalapi-simple.onrender.com/api/public/properties';

  // ── Fetch ─────────────────────────────────────────────────────────────────
  Future<void> _fetchProperties() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http
          .get(Uri.parse(_apiUrl))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        if (json['success'] == true) {
          // API wraps the array inside data.items, not data directly
          final List<dynamic> dataList =
              (json['data']['items'] as List<dynamic>?) ?? [];

          setState(() {
            _allProperties =
                dataList.map((item) => _propertyFromJson(item)).toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = json['message'] ?? 'Failed to load properties.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Server error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error. Please check your connection.';
        _isLoading = false;
      });
    }
  }

  Property _propertyFromJson(Map<String, dynamic> json) {
    final images = json['images'] as List<dynamic>? ?? [];
    final imageUrl = images.isNotEmpty
        ? (images.first['url'] as String? ?? _placeholderImage(json['id']))
        : _placeholderImage(json['id']);

    final category =
        (json['category'] as Map<String, dynamic>?)?['name'] as String? ?? '';

    final createdBy = json['createdBy'] as Map<String, dynamic>? ?? {};
    final agentName = createdBy['fullname'] as String? ?? '';
    final agentUsername = createdBy['username'] as String? ?? '';
    final agentProfile = createdBy['profile'] as String?;

    return Property(
      id: json['id'].toString(),
      title: json['title'] as String? ?? 'Untitled',
      location: json['address'] as String? ?? 'Phnom Penh',
      imageUrl: imageUrl,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      beds: json['beds'] as int? ?? 1,
      baths: json['baths'] as int? ?? 1,
      isAvailable: json['available'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      electricityCost: (json['electricityCost'] as num?)?.toDouble() ?? 0,
      waterCost: (json['waterCost'] as num?)?.toDouble() ?? 0,
      category: category,
      agentName: agentName,
      agentUsername: agentUsername,
      agentProfile: agentProfile,
    );
  }

  String _placeholderImage(dynamic id) {
    final seed = (id is int ? id : int.tryParse(id.toString()) ?? 1) * 100;
    return 'https://picsum.photos/seed/$seed/800/600';
  }

  // ── Filtered list ─────────────────────────────────────────────────────────
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

      // FIX: parse to double so prices like 250.5 also work correctly
      final matchesPrice = p.price < double.parse(_selectedPrice);
      return matchesSearch && matchesFilter && matchesPrice;
    }).toList();
  }

  void _goToProfile() {
    final isLoggedIn = AuthService.isLoggedIn;
    if (isLoggedIn) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const ProfilePage()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const LoginPage()));
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
    _headerSlide =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _pageController, curve: Curves.easeOutCubic),
        );
    _searchScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pageController, curve: Curves.elasticOut),
    );

    _pageController.forward();
    _fetchProperties();
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
            // ── Hero Header ─────────────────────────────────────────────
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
                              child: Icon(Icons.home_work_rounded,
                                  size: 180, color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 24),
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
                                                color: Colors.white
                                                    .withOpacity(0.85),
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
                                            backgroundColor:
                                            const Color(0xFF10B981),
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

            // ── Search Bar ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: ScaleTransition(
                  scale: _searchScale,
                  child: Container(
                    height: 66,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(30),
                      border:
                      Border.all(color: Colors.white.withOpacity(0.7)),
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
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: Color(0xFF10B981), size: 28),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Filters + List ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    if (_isLoading)
                      _buildLoadingState()
                    else if (_errorMessage != null)
                      _buildErrorState()
                    else if (_filteredProperties.isEmpty)
                        _buildEmptyState()
                      else
                        _buildPropertyList(),
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

  // ── State widgets ──────────────────────────────────────────────────────────

  Widget _buildLoadingState() {
    return Column(
      children: List.generate(
        2,
            (_) => Container(
          margin: const EdgeInsets.only(bottom: 28),
          height: 360,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF10B981),
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(Icons.cloud_off_rounded,
                size: 64, color: Color(0xFF10B981)),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 15, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchProperties,
              icon: const Icon(Icons.refresh_rounded),
              label: Text("Retry", style: GoogleFonts.poppins()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded,
                size: 64, color: Color(0xFF10B981)),
            const SizedBox(height: 16),
            Text(
              "No properties match your filters.",
              style: GoogleFonts.poppins(
                  fontSize: 15, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredProperties.length,
      itemBuilder: (context, index) {
        final property = _filteredProperties[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 600 + (index * 120)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => Transform.translate(
            offset: Offset(0, 40 * (1 - value)),
            child: Opacity(opacity: value, child: child),
          ),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProductDetailPage(property: property)),
            ),
            // ── Use the extracted PropertyCard widget ──────────────────
            child: PropertyCard(property: property, index: index),
          ),
        );
      },
    );
  }

  // ── UI helpers ─────────────────────────────────────────────────────────────

  Widget _buildAnimatedFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 220),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          padding:
          const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
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
              color:
              isSelected ? Colors.transparent : Colors.grey.shade200,
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
              color:
              isSelected ? Colors.white : const Color(0xFF374151),
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
        icon: const Icon(Icons.arrow_drop_down_rounded,
            color: Color(0xFF10B981)),
        style: GoogleFonts.poppins(
          fontSize: 15.5,
          color: const Color(0xFF1F2937),
          fontWeight: FontWeight.w600,
        ),
        onChanged: (v) => setState(() => _selectedPrice = v!),
        // FIX: added 'Any Price' (9999) as the first/default option
        items: [
          const DropdownMenuItem(value: '9999', child: Text('Any Price')),
          ...['100', '200', '300', '400', '500', '600', '700', '800'].map(
                (v) => DropdownMenuItem(value: v, child: Text('Under \$$v')),
          ),
        ],
      ),
    );
  }
}

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