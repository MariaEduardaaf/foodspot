import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/restaurant_provider.dart';
import '../models/restaurant.dart';
import 'restaurant_details_screen.dart';

class RestaurantListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurants = ref.watch(filteredRestaurantsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
        iconTheme: const IconThemeData(color: Colors.white), 
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Restaurants',
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                ref.read(searchProvider.notifier).state = value;
              },
            ),
          ),
          Expanded(
            child: restaurants.isEmpty
                ? const Center(
                    child: Text(
                      'No restaurants found.',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final Restaurant restaurant = restaurants[index];

                      // Define image path based on restaurant name
                      final imagePath = _getImagePath(restaurant.name);

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.grey[900],
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(15),
                            leading: Hero(
                              tag: 'restaurant-${restaurant.id}',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  imagePath,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              restaurant.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              restaurant.cuisine,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                            onTap: () {
                              // Navigate to the details screen with image path
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RestaurantDetailsScreen(
                                    restaurant: restaurant,
                                    imagePath: imagePath, // Pass the image path
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// Get image path based on restaurant name
  String _getImagePath(String restaurantName) {
    switch (restaurantName) {
      case "The Smokehouse":
        return 'assets/images/meat-platter-perfect.jpg';
      case "Pinocchio's Pizza":
        return 'assets/images/pizza-pinocchio.jpeg';
      case "Felipe's Taqueria":
        return 'assets/images/taqueria.jpeg';
      case "Tasty Burger":
        return 'assets/images/burguer.jpeg';
      default:
        return 'assets/images/default.jpg';
    }
  }
}
