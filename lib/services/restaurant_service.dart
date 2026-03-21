import 'package:campus_food_finder_app/models/restaurant.dart';
import 'package:campus_food_finder_app/services/database_helper.dart';

class RestaurantService {
  static Future<int> insertRestaurant(Restaurant restaurant) async {
    final db = await DatabaseHelper.instance.database;
    return db.insert('restaurants', restaurant.toMap());
  }

  static Future<List<Restaurant>> getRestaurants({
    String search = '',
    String cuisine = 'All',
    String priceCategory = 'All',
    bool openNow = false,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('restaurants', orderBy: 'distanceMiles ASC');
    final restaurants = maps.map(Restaurant.fromMap).toList();

    return restaurants.where((restaurant) {
      final matchesSearch = search.isEmpty ||
          restaurant.name.toLowerCase().contains(search.toLowerCase()) ||
          restaurant.cuisine.toLowerCase().contains(search.toLowerCase());
      final matchesCuisine =
          cuisine == 'All' || restaurant.cuisine == cuisine;
      final matchesPrice =
          priceCategory == 'All' || restaurant.priceCategory == priceCategory;
      final matchesOpen = !openNow || restaurant.isOpen;
      return matchesSearch && matchesCuisine && matchesPrice && matchesOpen;
    }).toList();
  }

  static Future<Restaurant?> getRestaurantById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      'restaurants',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return Restaurant.fromMap(maps.first);
  }

  static Future<List<String>> getAvailableCuisines() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.rawQuery(
      'SELECT DISTINCT cuisine FROM restaurants ORDER BY cuisine ASC',
    );
    return ['All', ...maps.map((e) => e['cuisine'] as String)];
  }
}
