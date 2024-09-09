import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/restaurant.dart';

class LocalDataService {
  Future<List<Restaurant>> fetchRestaurants() async {
    try {
      // Carrega o arquivo JSON da pasta assets
      final jsonString = await rootBundle.loadString('assets/data/restaurants.json');
      final Map<String, dynamic> jsonResponse = json.decode(jsonString);
      final List<dynamic> restaurantList = jsonResponse['restaurants'];

      // Retorna uma lista de objetos Restaurant
      return restaurantList.map((json) => Restaurant.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao carregar restaurantes: $e');
      return [];
    }
  }
}
