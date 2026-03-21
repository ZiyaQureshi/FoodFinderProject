class Favorite {
  final int? id;
  final int restaurantId;
  final String review;

  const Favorite({
    this.id,
    required this.restaurantId,
    required this.review,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'review': review,
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'] as int?,
      restaurantId: map['restaurantId'] as int,
      review: map['review'] as String? ?? '',
    );
  }
}
