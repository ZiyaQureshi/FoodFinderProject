import 'package:campus_food_finder_app/models/budget.dart';
import 'package:campus_food_finder_app/models/filter_preferences.dart';
import 'package:campus_food_finder_app/models/restaurant.dart';
import 'package:campus_food_finder_app/services/database_helper.dart';
import 'package:campus_food_finder_app/services/budget_service.dart';
import 'package:campus_food_finder_app/services/filter_service.dart';
import 'package:campus_food_finder_app/services/restaurant_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeedDataService {
  static Future<void> seedIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final seeded = prefs.getBool('seeded');
    if (seeded == true) return;

    final db = await DatabaseHelper.instance.database;
    await db.delete('favorites');
    await db.delete('meals');
    await db.delete('restaurants');
    await db.delete('budget');
    await db.delete('filters');

    for (final restaurant in _restaurants) {
      await RestaurantService.insertRestaurant(restaurant);
    }

    await BudgetService.saveBudget(
      const Budget(
        weeklyBudget: 60.0,
        weeklySpent: 24.50,
        weekLabel: 'This Week',
      ),
    );

    await FilterService.savePreferences(FilterPreferences.defaults);

    await prefs.setString('displayName', 'Student');
    await prefs.setString('matcherProfile', 'Budget-conscious foodie');
    await prefs.setBool('seeded', true);
  }

  static final List<Restaurant> _restaurants = [
    const Restaurant(
      name: 'Panther Pizza',
      cuisine: 'Pizza',
      priceCategory: '\$',
      rating: 4.5,
      isOpen: true,
      hours: '10:00 AM - 10:00 PM',
      distanceMiles: 0.3,
      description: 'Fast pizza slices close to campus with combo deals for students.',
      imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591',
    ),
    const Restaurant(
      name: 'Green Bowl',
      cuisine: 'Healthy',
      priceCategory: '\$\$',
      rating: 4.7,
      isOpen: true,
      hours: '11:00 AM - 9:00 PM',
      distanceMiles: 0.5,
      description: 'Healthy bowls, wraps, and smoothies with customizable toppings.',
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
    ),
    const Restaurant(
      name: 'Campus Curry',
      cuisine: 'Indian',
      priceCategory: '\$',
      rating: 4.4,
      isOpen: false,
      hours: '12:00 PM - 8:00 PM',
      distanceMiles: 0.7,
      description: 'Affordable curry plates, naan, and rice bowls with student specials.',
      imageUrl: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe',
    ),
    const Restaurant(
      name: 'Taco Sprint',
      cuisine: 'Mexican',
      priceCategory: '\$',
      rating: 4.3,
      isOpen: true,
      hours: '9:00 AM - 11:00 PM',
      distanceMiles: 0.4,
      description: 'Quick tacos and burritos for students between classes.',
      imageUrl: 'https://images.unsplash.com/photo-1552332386-f8dd00dc2f85',
    ),
    const Restaurant(
      name: 'Noodle Lab',
      cuisine: 'Asian',
      priceCategory: '\$\$',
      rating: 4.6,
      isOpen: true,
      hours: '11:30 AM - 9:30 PM',
      distanceMiles: 0.8,
      description: 'Ramen, stir-fry noodles, and dumplings in a casual study-friendly space.',
      imageUrl: 'https://images.unsplash.com/photo-1617093727343-374698b1b08d',
    ),
    const Restaurant(
      name: 'Sunrise Cafe',
      cuisine: 'Cafe',
      priceCategory: '\$',
      rating: 4.2,
      isOpen: true,
      hours: '7:30 AM - 5:00 PM',
      distanceMiles: 0.2,
      description: 'Coffee, pastries, sandwiches, and breakfast all day.',
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
  ];
}
