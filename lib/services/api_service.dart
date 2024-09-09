import 'dart:convert';
import '../models/restaurant.dart';

class ApiService {
  final String apiUrl = 'mocked'; // Simulated API URL

  /// Simulates a GET request to fetch all restaurants
  Future<List<Restaurant>> fetchRestaurants() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

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

    // Parse the JSON mock data
    final jsonResponse = json.decode(mockData) as Map<String, dynamic>;
    final restaurantList = jsonResponse['restaurants'] as List<dynamic>;

    // Return a list of Restaurant objects
    return restaurantList.map((json) => Restaurant.fromJson(json)).toList();
  }

  /// Simulates a PATCH request to update a restaurant's details
  Future<void> updateRestaurant(int id, Map<String, dynamic> updates) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate successful update
    print('Restaurant $id updated with: $updates');
  }
}
