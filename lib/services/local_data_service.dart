import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/restaurant.dart';

class LocalDataService {
  Future<List<Restaurant>> fetchRestaurants() async {
    final jsonString = await rootBundle.loadString('assets/data/restaurants.json');
    final Map<String, dynamic> jsonResponse = json.decode(jsonString);
    final List<dynamic> restaurantList = jsonResponse['restaurants'];

    return restaurantList.map((json) => Restaurant.fromJson(json)).toList();
  }
}
