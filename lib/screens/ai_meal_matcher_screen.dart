import 'package:campus_food_finder_app/models/restaurant.dart';
import 'package:campus_food_finder_app/services/meal_matcher_service.dart';
import 'package:campus_food_finder_app/services/restaurant_service.dart';
import 'package:campus_food_finder_app/widgets/info_chip.dart';
import 'package:flutter/material.dart';

class AiMealMatcherScreen extends StatefulWidget {
  const AiMealMatcherScreen({super.key});

  @override
  State<AiMealMatcherScreen> createState() => _AiMealMatcherScreenState();
}

class _AiMealMatcherScreenState extends State<AiMealMatcherScreen> {
  final moods = ['Comfort', 'Healthy', 'Quick'];
  final times = ['10 min', '20 min', '30+ min'];

  String selectedMood = 'Comfort';
  String selectedTime = '20 min';
  double budgetValue = 12;
  Restaurant? result;

  Future<void> _findMatch() async {
    final restaurants = await RestaurantService.getRestaurants();
    final match = MealMatcherService.match(
      restaurants: restaurants,
      mood: selectedMood,
      budget: budgetValue,
      timeOption: selectedTime,
    );

    if (!mounted) return;
    setState(() => result = match);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Meal Matcher')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Mood Options',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: moods.map((mood) {
              return InfoChip(
                label: mood,
                selected: selectedMood == mood,
                onTap: () => setState(() => selectedMood = mood),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Budget Adjuster',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Slider(
                    value: budgetValue,
                    min: 5,
                    max: 25,
                    divisions: 20,
                    label: '\$${budgetValue.round()}',
                    onChanged: (value) => setState(() => budgetValue = value),
                  ),
                  Text('Target meal cost: under \$${budgetValue.toStringAsFixed(0)}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Time Options',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: times.map((time) {
              return InfoChip(
                label: time,
                selected: selectedTime == time,
                onTap: () => setState(() => selectedTime = time),
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: _findMatch,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text('Find Match'),
          ),
          const SizedBox(height: 20),
          if (result != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recommended Spot',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      result!.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text('${result!.cuisine} • ${result!.priceCategory}'),
                    const SizedBox(height: 4),
                    Text(result!.description),
                    const SizedBox(height: 8),
                    Text(
                      'Why this match: fits your $selectedMood mood, ${selectedTime.toLowerCase()} window, and budget.',
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
