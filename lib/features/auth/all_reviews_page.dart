import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllReviewsPage extends StatefulWidget {
  final List<Map<String, dynamic>> reviews;

  const AllReviewsPage({super.key, required this.reviews});

  @override
  State<AllReviewsPage> createState() => _AllReviewsPageState();
}

class _AllReviewsPageState extends State<AllReviewsPage> {
  String _selectedFilter = "All";
  final List<String> _filters = ["All", "5", "4", "3", "2", "1"];

  @override
  Widget build(BuildContext context) {
    // Filter the reviews based on the selected chip
    final filteredReviews = _selectedFilter == "All"
        ? widget.reviews
        : widget.reviews
              .where((r) => r['rating'].toString() == _selectedFilter)
              .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F5F0),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFF1E3A8A),
          ),
        ),
        title: Text(
          "All Reviews",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F5F0), Color(0xFFFCFAF7)],
          ),
        ),
        child: Column(
          children: [
            // Filter Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(
                        filter == "All" ? "All Reviews" : "$filter ★",
                      ),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() => _selectedFilter = filter);
                      },
                      selectedColor: const Color(0xFF1E3A8A),
                      backgroundColor: Colors.white,
                      labelStyle: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Reviews List
            Expanded(
              child: filteredReviews.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredReviews.length,
                      itemBuilder: (context, index) {
                        return _buildUserReviewCard(filteredReviews[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_outline_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No $_selectedFilter star reviews yet",
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // Re-using your exact style for the Review Cards
  Widget _buildUserReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(review["image"]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review["name"],
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    Text(
                      review["date"],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review["rating"]
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: index < review["rating"]
                        ? Colors.amber
                        : Colors.grey[300],
                    size: 18,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review["description"],
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
