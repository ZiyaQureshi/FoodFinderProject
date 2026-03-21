import 'package:campus_food_finder_app/services/favorite_service.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<FavoriteWithRestaurant> favorites = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await FavoriteService.getFavorites();
    if (!mounted) return;
    setState(() => favorites = data);
  }

  Future<void> _remove(int restaurantId) async {
    await FavoriteService.removeFavorite(restaurantId);
    await _load();
  }

  Future<void> _editReview(FavoriteWithRestaurant item) async {
    final controller = TextEditingController(text: item.favorite.review);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Review for ${item.restaurant.name}'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(hintText: 'Write your review'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await FavoriteService.updateReview(
                restaurantId: item.restaurant.id!,
                review: controller.text.trim(),
              );
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: favorites.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 180),
                  Icon(Icons.favorite_border, size: 60),
                  SizedBox(height: 12),
                  Center(
                    child: Text('No favorites saved yet. Explore food options first.'),
                  ),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: favorites.length,
                itemBuilder: (_, index) {
                  final item = favorites[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.restaurant.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(item.restaurant.description),
                          const SizedBox(height: 8),
                          Text(
                            item.favorite.review.isEmpty
                                ? 'No review yet.'
                                : 'Review: ${item.favorite.review}',
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => _editReview(item),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Review'),
                              ),
                              const SizedBox(width: 10),
                              FilledButton.icon(
                                onPressed: () => _remove(item.restaurant.id!),
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Remove'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
              ),
      ),
    );
  }
}
