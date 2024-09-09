import 'dart:convert';
import '../models/restaurant.dart';

class LocalDataService {
  /// Simulates fetching restaurant data
  Future<List<Restaurant>> fetchRestaurants() async {
    // Mock restaurant data
    const mockData = '''
    {
      "restaurants": [
        {
          "id": 1,
          "name": "The Smokehouse",
          "cuisine": "Barbecue"
        },
        {
          "id": 2,
          "name": "Pinocchio's Pizza",
          "cuisine": "Italian"
        },
        {
          "id": 3,
          "name": "Felipe's Taqueria",
          "cuisine": "Mexican"
        },
        {
          "id": 4,
          "name": "Tasty Burger",
          "cuisine": "American"
        }
      ]
    }
    ''';

    // Simulate a short delay (50ms)
    await Future.delayed(const Duration(milliseconds: 50));

    try {
      // Parse the JSON mock data
      final jsonResponse = json.decode(mockData) as Map<String, dynamic>;
      final restaurantList = jsonResponse['restaurants'] as List<dynamic>;

      // Return a list of Restaurant objects
      return restaurantList.map((json) => Restaurant.fromJson(json)).toList();
    } catch (e) {
      // Log the error and return an empty list
      print('Error loading restaurants: $e');
      return [];
    }
  }
}
