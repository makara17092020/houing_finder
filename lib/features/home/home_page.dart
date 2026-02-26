import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../property/models/property.dart';
import '../property/product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _selectedPrice = '200'; // Default price limit

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
      final matchesPrice =
          int.parse(p.price.toString()) < int.parse(_selectedPrice);
      return matchesSearch && matchesFilter && matchesPrice;
    }).toList();
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
          child: CustomScrollView(
            slivers: [
              // Clean Navbar
              SliverAppBar(
                floating: true,
                pinned: true,
                elevation: 2,
                backgroundColor: Colors.white,
                expandedHeight: 100,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
                  title: Text(
                    "Housing Finder",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32), // ← More clean space
                      // Search Bar
                      Container(
                        height: 58,
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
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) =>
                              setState(() => _searchQuery = value),
                          decoration: InputDecoration(
                            hintText: "Search in Phnom Penh...",
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey[500],
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: Color(0xFF1E3A8A),
                              size: 26,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Gradient Green Filter Buttons
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...['All', 'Near School', 'Available']
                                .map(
                                  (filter) => Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: GestureDetector(
                                      onTap: () => setState(
                                        () => _selectedFilter = filter,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: _selectedFilter == filter
                                              ? const LinearGradient(
                                                  colors: [
                                                    Color(0xFF10B981),
                                                    Color(0xFF34D399),
                                                  ],
                                                )
                                              : null,
                                          color: _selectedFilter == filter
                                              ? null
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          border: Border.all(
                                            color: _selectedFilter == filter
                                                ? Colors.transparent
                                                : Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Text(
                                          filter,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: _selectedFilter == filter
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            const SizedBox(width: 12),
                            // Price Dropdown
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: DropdownButton<String>(
                                value: _selectedPrice,
                                underline: const SizedBox(),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedPrice = newValue!;
                                  });
                                },
                                items:
                                    [
                                      '100',
                                      '200',
                                      '300',
                                      '400',
                                      '500',
                                      '600',
                                      '700',
                                      '800',
                                    ].map<DropdownMenuItem<String>>((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          'Under \$$value',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      Text(
                        "Featured Homes in Phnom Penh",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredProperties.length,
                        itemBuilder: (context, index) {
                          final property = _filteredProperties[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailPage(property: property),
                                ),
                              );
                            },
                            child: _buildPropertyCard(property),
                          );
                        },
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyCard(Property property) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  property.imageUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "\$${property.price}/mo",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: GoogleFonts.poppins(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFF1E3A8A),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        property.location,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildSpec(
                        Icons.king_bed_outlined,
                        "${property.beds} Beds",
                      ),
                      const SizedBox(width: 24),
                      _buildSpec(
                        Icons.bathtub_outlined,
                        "${property.baths} Baths",
                      ),
                      const Spacer(),
                      if (property.isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            "Available",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 22,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        property.rating.toString(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
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
    );
  }

  Widget _buildSpec(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1E3A8A), size: 20),
        const SizedBox(width: 6),
        Text(text, style: GoogleFonts.poppins(fontSize: 15)),
      ],
    );
  }
}
