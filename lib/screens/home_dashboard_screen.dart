import 'package:campus_food_finder_app/models/budget.dart';
import 'package:campus_food_finder_app/models/restaurant.dart';
import 'package:campus_food_finder_app/services/budget_service.dart';
import 'package:campus_food_finder_app/services/restaurant_service.dart';
import 'package:campus_food_finder_app/services/settings_service.dart';
import 'package:flutter/material.dart';

class HomeDashboardScreen extends StatefulWidget {
  final VoidCallback openMealMatcher;
  final VoidCallback openFoodFinder;
  final VoidCallback openBudget;
  final VoidCallback openFavorites;

  const HomeDashboardScreen({
    super.key,
    required this.openMealMatcher,
    required this.openFoodFinder,
    required this.openBudget,
    required this.openFavorites,
  });

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  String displayName = 'Student';
  Budget? budget;
  List<Restaurant> nearby = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loadedName = await SettingsService.getDisplayName();
    final loadedBudget = await BudgetService.getBudget();
    final restaurants = await RestaurantService.getRestaurants();
    if (!mounted) return;
    setState(() {
      displayName = loadedName;
      budget = loadedBudget;
      nearby = restaurants.take(3).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final spent = budget?.weeklySpent ?? 0;
    final cap = budget?.weeklyBudget ?? 0;
    final remaining = (cap - spent).clamp(0, double.infinity);

    return Scaffold(
      appBar: AppBar(title: const Text('Home Dashboard')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Welcome, $displayName',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Budget',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Text('\$${spent.toStringAsFixed(2)} spent'),
                    Text('\$${remaining.toStringAsFixed(2)} remaining'),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: cap == 0 ? 0 : (spent / cap).clamp(0, 1),
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: widget.openMealMatcher,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.deepOrange.shade400),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'AI Meal Matcher\nGet a recommendation for your mood, budget, and time.',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 18),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Quick Access',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _QuickButton(
                    label: 'Find Food',
                    icon: Icons.search,
                    onTap: widget.openFoodFinder,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickButton(
                    label: 'Budget',
                    icon: Icons.savings,
                    onTap: widget.openBudget,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickButton(
                    label: 'Favorites',
                    icon: Icons.favorite,
                    onTap: widget.openFavorites,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'Nearby Now',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            const SizedBox(height: 10),
            ...nearby.map(
              (restaurant) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: ListTile(
                    title: Text(restaurant.name),
                    subtitle: Text(
                      '${restaurant.cuisine} • ${restaurant.distanceMiles.toStringAsFixed(1)} mi',
                    ),
                    trailing: const Icon(Icons.location_on_outlined),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
