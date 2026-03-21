import 'package:campus_food_finder_app/screens/ai_meal_matcher_screen.dart';
import 'package:campus_food_finder_app/screens/budget_tracker_screen.dart';
import 'package:campus_food_finder_app/screens/favorites_screen.dart';
import 'package:campus_food_finder_app/screens/food_finder_screen.dart';
import 'package:campus_food_finder_app/screens/home_dashboard_screen.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;

  late final List<Widget> _screens = [
    HomeDashboardScreen(
      openMealMatcher: () => setState(() => _index = 4),
      openFoodFinder: () => setState(() => _index = 1),
      openBudget: () => setState(() => _index = 2),
      openFavorites: () => setState(() => _index = 3),
    ),
    const FoodFinderScreen(),
    const BudgetTrackerScreen(),
    const FavoritesScreen(),
    const AiMealMatcherScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index > 3 ? 0 : _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Find Food'),
          NavigationDestination(icon: Icon(Icons.savings_outlined), label: 'Budget'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Favorites'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _index = 4),
        icon: const Icon(Icons.auto_awesome),
        label: const Text('AI Match'),
      ),
    );
  }
}
