import 'package:campus_food_finder_app/models/restaurant.dart';

class MealMatcherService {
  static Restaurant? match({
    required List<Restaurant> restaurants,
    required String mood,
    required double budget,
    required String timeOption,
  }) {
    if (restaurants.isEmpty) return null;

    final filtered = restaurants.where((restaurant) {
      final priceScore = switch (restaurant.priceCategory) {
        '\$' => 12.0,
        '\$\$' => 20.0,
        _ => 30.0,
      };

      final matchesBudget = priceScore <= budget;
      final matchesMood = switch (mood) {
        'Comfort' => ['Pizza', 'Indian', 'Mexican', 'Cafe'].contains(restaurant.cuisine),
        'Healthy' => ['Healthy', 'Cafe'].contains(restaurant.cuisine),
        'Quick' => restaurant.distanceMiles <= 0.5,
        _ => true,
      };

      final matchesTime = switch (timeOption) {
        '10 min' => restaurant.distanceMiles <= 0.3,
        '20 min' => restaurant.distanceMiles <= 0.6,
        _ => true,
      };

      return matchesBudget && matchesMood && matchesTime;
    }).toList();

    filtered.sort((a, b) {
      final scoreA = (a.rating * 10) - (a.distanceMiles * 3);
      final scoreB = (b.rating * 10) - (b.distanceMiles * 3);
      return scoreB.compareTo(scoreA);
    });

    return filtered.isNotEmpty ? filtered.first : restaurants.first;
  }
}
