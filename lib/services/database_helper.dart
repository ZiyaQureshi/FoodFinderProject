import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> initDatabase() async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'budget_bites.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return _database!;
  }

  Future<Database> get database async => _database ?? await initDatabase();

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE restaurants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cuisine TEXT NOT NULL,
        priceCategory TEXT NOT NULL,
        rating REAL NOT NULL,
        isOpen INTEGER NOT NULL,
        hours TEXT NOT NULL,
        distanceMiles REAL NOT NULL,
        description TEXT NOT NULL,
        imageUrl TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE meals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        restaurantId INTEGER NOT NULL,
        mealName TEXT NOT NULL,
        cost REAL NOT NULL,
        date TEXT NOT NULL,
        cuisine TEXT NOT NULL,
        FOREIGN KEY (restaurantId) REFERENCES restaurants (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE budget (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        weeklyBudget REAL NOT NULL,
        weeklySpent REAL NOT NULL,
        weekLabel TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        restaurantId INTEGER NOT NULL UNIQUE,
        review TEXT,
        FOREIGN KEY (restaurantId) REFERENCES restaurants (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE filters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cuisine TEXT NOT NULL,
        priceCategory TEXT NOT NULL,
        openNow INTEGER NOT NULL
      )
    ''');
  }
}
