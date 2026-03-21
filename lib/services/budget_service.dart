import 'package:campus_food_finder_app/models/budget.dart';
import 'package:campus_food_finder_app/models/meal.dart';
import 'package:campus_food_finder_app/services/database_helper.dart';

class BudgetService {
  static Future<Budget> getBudget() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('budget', limit: 1);
    if (maps.isEmpty) {
      final budget = const Budget(
        weeklyBudget: 50,
        weeklySpent: 0,
        weekLabel: 'This Week',
      );
      await saveBudget(budget);
      return budget;
    }
    return Budget.fromMap(maps.first);
  }

  static Future<void> saveBudget(Budget budget) async {
    final db = await DatabaseHelper.instance.database;
    final existing = await db.query('budget', limit: 1);
    if (existing.isEmpty) {
      await db.insert('budget', budget.toMap());
    } else {
      await db.update(
        'budget',
        budget.toMap(),
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    }
  }

  static Future<void> addExpense(Meal meal) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('meals', meal.toMap());
    final budget = await getBudget();
    await saveBudget(
      budget.copyWith(weeklySpent: budget.weeklySpent + meal.cost),
    );
  }

  static Future<List<Meal>> getRecentMeals() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      'meals',
      orderBy: 'date DESC, id DESC',
      limit: 10,
    );
    return maps.map(Meal.fromMap).toList();
  }
}
