import 'package:campus_food_finder_app/models/restaurant.dart';
import 'package:campus_food_finder_app/services/favorite_service.dart';
import 'package:campus_food_finder_app/services/restaurant_service.dart';
import 'package:campus_food_finder_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final int restaurantId;

  const RestaurantDetailsScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<RestaurantDetailsScreen> createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  Restaurant? restaurant;
  bool isFavorite = false;
  final _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final loadedRestaurant =
        await RestaurantService.getRestaurantById(widget.restaurantId);
    final loadedFavorite = await FavoriteService.isFavorite(widget.restaurantId);
    if (!mounted) return;
    setState(() {
      restaurant = loadedRestaurant;
      isFavorite = loadedFavorite;
    });
  }

  Future<void> _toggleFavorite() async {
    if (restaurant == null) return;
    final wasAlreadyFavorite = isFavorite;

    if (isFavorite) {
      await FavoriteService.removeFavorite(widget.restaurantId);
    } else {
      await FavoriteService.addFavorite(
        restaurantId: widget.restaurantId,
        review: _reviewController.text,
      );
    }

    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasAlreadyFavorite
              ? 'Removed from favorites'
              : 'Added to favorites',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = restaurant;
    if (item == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              item.imageUrl,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 220,
                color: Colors.orange.shade100,
                child: const Icon(Icons.restaurant, size: 60),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text('${item.cuisine} • ${item.priceCategory} • ${item.hours}'),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 6),
              Text(item.rating.toString()),
              const SizedBox(width: 14),
              Text(item.isOpen ? 'Open now' : 'Currently closed'),
            ],
          ),
          const SizedBox(height: 16),
          Text(item.description),
          const SizedBox(height: 18),
          const Text(
            'Quick Review',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _reviewController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Write a short review before saving...',
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
            icon: isFavorite ? Icons.delete_outline : Icons.favorite,
            onPressed: _toggleFavorite,
          ),
          const SizedBox(height: 20),
          const Text(
            'Menu Ideas',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 10),
          const Card(
            child: ListTile(
              title: Text('Student Combo'),
              subtitle: Text('Main item + drink'),
              trailing: Text('\$8.99'),
            ),
          ),
          const SizedBox(height: 10),
          const Card(
            child: ListTile(
              title: Text('Budget Pick'),
              subtitle: Text('Affordable meal under \$7'),
              trailing: Text('\$6.49'),
            ),
          ),
        ],
      ),
    );
  }
}
