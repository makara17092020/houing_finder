class Property {
  final String id;
  final String title;
  final String location;
  final String imageUrl;
  final double price;
  final double rating;
  final int beds;
  final int baths;
  final bool isAvailable;

  // ── Extended API fields ──────────────────────────────────────────────────
  final String description;
  final double electricityCost;
  final double waterCost;
  final String category;
  final String agentName;
  final String agentUsername;
  final String? agentProfile; // nullable – API returns null

  Property({
    required this.id,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.beds,
    required this.baths,
    required this.isAvailable,
    this.description = '',
    this.electricityCost = 0,
    this.waterCost = 0,
    this.category = '',
    this.agentName = '',
    this.agentUsername = '',
    this.agentProfile,
  });
}