import 'package:flutter/material.dart';
import '../models/restaurant.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final Restaurant restaurant;
  final String imagePath;

  const RestaurantDetailsScreen({
    Key? key,
    required this.restaurant,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Restaurant image
          Hero(
            tag: 'restaurant-${restaurant.id}',
            child: Image.asset(
              imagePath,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          // Restaurant name
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              restaurant.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ),
          // Restaurant cuisine
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Cuisine: ${restaurant.cuisine}',
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
