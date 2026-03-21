import 'package:campus_food_finder_app/models/budget.dart';
import 'package:campus_food_finder_app/models/meal.dart';
import 'package:campus_food_finder_app/services/budget_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetTrackerScreen extends StatefulWidget {
  const BudgetTrackerScreen({super.key});

  @override
  State<BudgetTrackerScreen> createState() => _BudgetTrackerScreenState();
}

class _BudgetTrackerScreenState extends State<BudgetTrackerScreen> {
  Budget? budget;
  List<Meal> recentMeals = [];
  final _mealController = TextEditingController();
  final _costController = TextEditingController();
  final _restaurantIdController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _mealController.dispose();
    _costController.dispose();
    _restaurantIdController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final loadedBudget = await BudgetService.getBudget();
    final meals = await BudgetService.getRecentMeals();
    if (!mounted) return;
    setState(() {
      budget = loadedBudget;
      recentMeals = meals;
    });
  }

  Future<void> _addExpense() async {
    final mealName = _mealController.text.trim();
    final cost = double.tryParse(_costController.text.trim());
    final restaurantId = int.tryParse(_restaurantIdController.text.trim()) ?? 1;

    if (mealName.isEmpty || cost == null) return;

    await BudgetService.addExpense(
      Meal(
        restaurantId: restaurantId,
        mealName: mealName,
        cost: cost,
        date: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
        cuisine: 'General',
      ),
    );

    _mealController.clear();
    _costController.clear();
    await _load();

    if (!mounted) return;

    final isOver = (budget?.weeklySpent ?? 0) > (budget?.weeklyBudget ?? 0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isOver
              ? 'Budget exceeded. Try lower-cost options next.'
              : 'Expense added.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loadedBudget = budget;
    final spent = loadedBudget?.weeklySpent ?? 0;
    final cap = loadedBudget?.weeklyBudget ?? 0;
    final remaining = cap - spent;
    final overBudget = remaining < 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Budget Tracker')),
      body: loadedBudget == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loadedBudget.weekLabel,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Total Spent: \$${spent.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            overBudget
                                ? 'Over budget by \$${remaining.abs().toStringAsFixed(2)}'
                                : 'Remaining: \$${remaining.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: overBudget ? Colors.red : Colors.green,
                            ),
                          ),
                          const SizedBox(height: 14),
                          LinearProgressIndicator(
                            value: cap == 0 ? 0 : (spent / cap).clamp(0, 1),
                            minHeight: 12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _smallStat('Daily avg', '\$${(spent / 7).toStringAsFixed(2)}'),
                              _smallStat('Meals', '${recentMeals.length}'),
                              _smallStat('Days left', '${DateTime.daysPerWeek - DateTime.now().weekday + 1}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Add Expense',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _mealController,
                    decoration: const InputDecoration(labelText: 'Meal name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _costController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Cost'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _restaurantIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Restaurant ID (sample data: 1-6)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _addExpense,
                    icon: const Icon(Icons.add),
                    label: const Text('Add expense'),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Recent Expenses',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  if (recentMeals.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(18),
                        child: Text('No expenses logged yet.'),
                      ),
                    ),
                  ...recentMeals.map(
                    (meal) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: ListTile(
                          title: Text(meal.mealName),
                          subtitle: Text(meal.date),
                          trailing: Text('\$${meal.cost.toStringAsFixed(2)}'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _smallStat(String label, String value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
