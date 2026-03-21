import 'package:campus_food_finder_app/models/filter_preferences.dart';
import 'package:campus_food_finder_app/services/database_helper.dart';

class FilterService {
  static Future<FilterPreferences> getPreferences() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('filters', limit: 1);
    if (maps.isEmpty) {
      await savePreferences(FilterPreferences.defaults);
      return FilterPreferences.defaults;
    }
    return FilterPreferences.fromMap(maps.first);
  }

  static Future<void> savePreferences(FilterPreferences preferences) async {
    final db = await DatabaseHelper.instance.database;
    final existing = await db.query('filters', limit: 1);
    if (existing.isEmpty) {
      await db.insert('filters', preferences.toMap());
    } else {
      await db.update(
        'filters',
        preferences.toMap(),
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    }
  }
}
