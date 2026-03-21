import 'package:campus_food_finder_app/models/filter_preferences.dart';
import 'package:campus_food_finder_app/models/restaurant.dart';
import 'package:campus_food_finder_app/screens/restaurant_details_screen.dart';
import 'package:campus_food_finder_app/services/filter_service.dart';
import 'package:campus_food_finder_app/services/restaurant_service.dart';
import 'package:campus_food_finder_app/widgets/info_chip.dart';
import 'package:campus_food_finder_app/widgets/restaurant_card.dart';
import 'package:flutter/material.dart';

class FoodFinderScreen extends StatefulWidget {
  const FoodFinderScreen({super.key});

  @override
  State<FoodFinderScreen> createState() => _FoodFinderScreenState();
}

class _FoodFinderScreenState extends State<FoodFinderScreen> {
  final _searchController = TextEditingController();
  List<Restaurant> restaurants = [];
  List<String> cuisines = ['All'];
  FilterPreferences preferences = FilterPreferences.defaults;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    final loadedPreferences = await FilterService.getPreferences();
    final availableCuisines = await RestaurantService.getAvailableCuisines();
    if (!mounted) return;
    setState(() {
      preferences = loadedPreferences;
      cuisines = availableCuisines;
    });
    await _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    final data = await RestaurantService.getRestaurants(
      search: _searchController.text,
      cuisine: preferences.cuisine,
      priceCategory: preferences.priceCategory,
      openNow: preferences.openNow,
    );
    if (!mounted) return;
    setState(() {
      restaurants = data;
      loading = false;
    });
  }

  Future<void> _updatePreferences(FilterPreferences newPrefs) async {
    await FilterService.savePreferences(newPrefs);
    setState(() => preferences = newPrefs);
    await _loadRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Finder')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search nearby food',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: _loadRestaurants,
                  icon: const Icon(Icons.tune),
                ),
              ),
              onChanged: (_) => _loadRestaurants(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  final cuisine = cuisines[index];
                  return InfoChip(
                    label: cuisine,
                    selected: preferences.cuisine == cuisine,
                    onTap: () => _updatePreferences(
                      preferences.copyWith(cuisine: cuisine),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: cuisines.length,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                InfoChip(
                  label: 'All Prices',
                  selected: preferences.priceCategory == 'All',
                  onTap: () => _updatePreferences(
                    preferences.copyWith(priceCategory: 'All'),
                  ),
                ),
                const SizedBox(width: 8),
                InfoChip(
                  label: '\$',
                  selected: preferences.priceCategory == '\$',
                  onTap: () => _updatePreferences(
                    preferences.copyWith(priceCategory: '\$'),
                  ),
                ),
                const SizedBox(width: 8),
                InfoChip(
                  label: '\$\$',
                  selected: preferences.priceCategory == '\$\$',
                  onTap: () => _updatePreferences(
                    preferences.copyWith(priceCategory: '\$\$'),
                  ),
                ),
                const Spacer(),
                Switch(
                  value: preferences.openNow,
                  onChanged: (value) => _updatePreferences(
                    preferences.copyWith(openNow: value),
                  ),
                ),
                const Text('Open'),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : restaurants.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.search_off, size: 48),
                              const SizedBox(height: 10),
                              const Text('No search results found.'),
                              TextButton(
                                onPressed: () => _updatePreferences(
                                  FilterPreferences.defaults,
                                ),
                                child: const Text('Reset filters'),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: restaurants.length,
                          itemBuilder: (_, index) {
                            final restaurant = restaurants[index];
                            return RestaurantCard(
                              restaurant: restaurant,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RestaurantDetailsScreen(
                                      restaurantId: restaurant.id!,
                                    ),
                                  ),
                                );
                                _loadRestaurants();
                              },
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
