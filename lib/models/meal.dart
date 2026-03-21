class Meal {
  final int? id;
  final int restaurantId;
  final String mealName;
  final double cost;
  final String date;
  final String cuisine;

  const Meal({
    this.id,
    required this.restaurantId,
    required this.mealName,
    required this.cost,
    required this.date,
    required this.cuisine,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'mealName': mealName,
      'cost': cost,
      'date': date,
      'cuisine': cuisine,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] as int?,
      restaurantId: map['restaurantId'] as int,
      mealName: map['mealName'] as String,
      cost: (map['cost'] as num).toDouble(),
      date: map['date'] as String,
      cuisine: map['cuisine'] as String,
    );
  }
}
