import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:houing_finder/features/auth/all_reviews_page.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _selectedRating = 0;
  final Set<String> _selectedFeedback = {};

  final List<String> _quickFeedbackOptions = [
    "Quick Feedback",
    "Friendly Agent",
    "Good location",
    "Fast response",
    "Poor Communication",
  ];

  // MOCK DATA: List of user reviews
  final List<Map<String, dynamic>> _userReviews = [
    {
      "name": "Sarah Jenkins",
      "image": "https://i.pravatar.cc/150?img=5",
      "rating": 5,
      "date": "2 days ago",
      "description":
          "Absolutely loved this apartment! Sophie was incredibly helpful and the location is perfect. Highly recommend.",
    },
    {
      "name": "Michael Chen",
      "image": "https://i.pravatar.cc/150?img=11",
      "rating": 4,
      "date": "1 week ago",
      "description":
          "Great place with lots of natural light. Only giving 4 stars because parking was a bit tricky to find.",
    },
    {
      "name": "Emma Thompson",
      "image": "https://i.pravatar.cc/150?img=9",
      "rating": 5,
      "date": "2 weeks ago",
      "description":
          "Super clean and exactly as pictured. The agent was fast to respond to all my questions.",
    },
    {
      "name": "David Miller",
      "image": "https://i.pravatar.cc/150?img=12",
      "rating": 3,
      "date": "1 month ago",
      "description": "It's an okay place, but a bit noisy at night.",
    },
  ];

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
    super.dispose();
  }

  void _submitReview() {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a star rating")),
      );
      return;
    }

    // TODO: Send to backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Thank you! Review submitted successfully ✨"),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Back button + Title
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    Text(
                      "Rate Your Experience",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Text(
                  "Your feedback helps other renters make better decisions.",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 32),

                // Property Info Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 40,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          "https://picsum.photos/id/1015/200/200",
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Apartment",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Agent: Sophie Lin",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 22,
                                ),
                                Text(
                                  " 4.8  •  124 reviews",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
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

                const SizedBox(height: 40),

                // Rating Breakdown
                _buildRatingBar(5, 84),
                _buildRatingBar(4, 26),
                _buildRatingBar(3, 8),
                _buildRatingBar(2, 2),
                _buildRatingBar(1, 1),

                const SizedBox(height: 40),

                // --- NEW USER REVIEWS SECTION ---
                Text(
                  "Recent Reviews",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 16),

                // Show only the first 3 reviews
                ..._userReviews
                    .take(3)
                    .map((review) => _buildUserReviewCard(review)),

                // See all reviews button
                // Locate this part in your ReviewPage.dart
                if (_userReviews.length > 3)
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // --- UPDATE THIS PART ---
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AllReviewsPage(reviews: _userReviews),
                          ),
                        );
                      },
                      child: Text(
                        "See all ${_userReviews.length} reviews",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 40),
                // --------------------------------

                // Star Rating Selector (Submit a review)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        const Divider(),
                        const SizedBox(height: 24),
                        Text(
                          "How would you rate this place?",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedRating = index + 1),
                              child: Icon(
                                index < _selectedRating
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: index < _selectedRating
                                    ? Colors.amber
                                    : Colors.grey[300],
                                size: 52,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Quick Feedback Chips
                Text(
                  "Quick Feedback",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _quickFeedbackOptions.map((label) {
                    final isSelected = _selectedFeedback.contains(label);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedFeedback.remove(label);
                          } else {
                            _selectedFeedback.add(label);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1E3A8A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          label,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 40),

                // Optional Comment
                Text(
                  "Tell us more (optional)",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "What did you like and dislike?",
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Submit Button
                SizedBox(
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
                        onTap: _submitReview,
                        child: Center(
                          child: Text(
                            "Submit Review",
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
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to build the individual user review boxes
  Widget _buildUserReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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

  Widget _buildRatingBar(int stars, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            "$stars ★",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: count / 100,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF1E3A8A),
                ),
                minHeight: 10,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "$count",
            style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
