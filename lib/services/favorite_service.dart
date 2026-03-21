import 'package:campus_food_finder_app/models/favorite.dart';
import 'package:campus_food_finder_app/models/restaurant.dart';
import 'package:campus_food_finder_app/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteWithRestaurant {
  final Favorite favorite;
  final Restaurant restaurant;

  FavoriteWithRestaurant({
    required this.favorite,
    required this.restaurant,
  });
}

class FavoriteService {
  static Future<void> addFavorite({
    required int restaurantId,
    String review = '',
  }) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(
      'favorites',
      Favorite(restaurantId: restaurantId, review: review).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> removeFavorite(int restaurantId) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'favorites',
      where: 'restaurantId = ?',
      whereArgs: [restaurantId],
    );
  }

  static Future<bool> isFavorite(int restaurantId) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      'favorites',
      where: 'restaurantId = ?',
      whereArgs: [restaurantId],
      limit: 1,
    );
    return maps.isNotEmpty;
  }

  static Future<List<FavoriteWithRestaurant>> getFavorites() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.rawQuery('''
      SELECT
        f.id as favoriteId,
        f.restaurantId,
        f.review,
        r.id,
        r.name,
        r.cuisine,
        r.priceCategory,
        r.rating,
        r.isOpen,
        r.hours,
        r.distanceMiles,
        r.description,
        r.imageUrl
      FROM favorites f
      INNER JOIN restaurants r ON r.id = f.restaurantId
      ORDER BY r.name ASC
    ''');

    return maps.map((map) {
      final restaurant = Restaurant.fromMap({
        'id': map['id'],
        'name': map['name'],
        'cuisine': map['cuisine'],
        'priceCategory': map['priceCategory'],
        'rating': map['rating'],
        'isOpen': map['isOpen'],
        'hours': map['hours'],
        'distanceMiles': map['distanceMiles'],
        'description': map['description'],
        'imageUrl': map['imageUrl'],
      });

      final favorite = Favorite(
        id: map['favoriteId'] as int?,
        restaurantId: map['restaurantId'] as int,
        review: map['review'] as String? ?? '',
      );

      return FavoriteWithRestaurant(
        favorite: favorite,
        restaurant: restaurant,
      );
    }).toList();
  }

  static Future<void> updateReview({
    required int restaurantId,
    required String review,
  }) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'favorites',
      {'review': review},
      where: 'restaurantId = ?',
      whereArgs: [restaurantId],
    );
  }
}
