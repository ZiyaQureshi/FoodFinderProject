class Restaurant {
  final int? id;
  final String name;
  final String cuisine;
  final String priceCategory;
  final double rating;
  final bool isOpen;
  final String hours;
  final double distanceMiles;
  final String description;
  final String imageUrl;

  const Restaurant({
    this.id,
    required this.name,
    required this.cuisine,
    required this.priceCategory,
    required this.rating,
    required this.isOpen,
    required this.hours,
    required this.distanceMiles,
    required this.description,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cuisine': cuisine,
      'priceCategory': priceCategory,
      'rating': rating,
      'isOpen': isOpen ? 1 : 0,
      'hours': hours,
      'distanceMiles': distanceMiles,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'] as int?,
      name: map['name'] as String,
      cuisine: map['cuisine'] as String,
      priceCategory: map['priceCategory'] as String,
      rating: (map['rating'] as num).toDouble(),
      isOpen: (map['isOpen'] as int) == 1,
      hours: map['hours'] as String,
      distanceMiles: (map['distanceMiles'] as num).toDouble(),
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }
}
