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
  });
}
