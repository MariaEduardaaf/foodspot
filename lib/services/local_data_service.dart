import 'dart:convert';
import '../models/restaurant.dart';

class LocalDataService {
  Future<List<Restaurant>> fetchRestaurants() async {
    try {
      // Simulando os dados dos restaurantes diretamente no código (mock)
      final mockData = '''
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

      // Reduzindo o atraso para 500ms
      await Future.delayed(Duration(milliseconds: 50));

      // Decodifica os dados do JSON
      final Map<String, dynamic> jsonResponse = json.decode(mockData);
      final List<dynamic> restaurantList = jsonResponse['restaurants'];

      // Retorna uma lista de objetos Restaurant
      return restaurantList.map((json) => Restaurant.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao carregar restaurantes: $e');
      return [];
    }
  }
}
