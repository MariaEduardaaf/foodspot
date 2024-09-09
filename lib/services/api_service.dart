import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/restaurant.dart';

class ApiService {
  final String apiUrl = 'mocked';  // API mockada

  // Método GET para buscar todos os restaurantes (simulando uma requisição HTTP)
  Future<List<Restaurant>> fetchRestaurants() async {
    // Simulando um atraso como se estivesse fazendo uma requisição real
    await Future.delayed(Duration(seconds: 2));

    // Dados mockados (substitui a chamada HTTP)
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

    // Simulando o parsing do JSON
    final Map<String, dynamic> jsonResponse = json.decode(mockData);
    final List<dynamic> restaurantList = jsonResponse['restaurants'];

    // Retornando a lista de restaurantes mockados
    return restaurantList.map((json) => Restaurant.fromJson(json)).toList();
  }

  // Simular um método PATCH para atualizar um restaurante
  Future<void> updateRestaurant(int id, Map<String, dynamic> updates) async {
    // Simulando um atraso
    await Future.delayed(Duration(seconds: 1));

    // Simulação de sucesso na atualização
    print('Restaurante $id atualizado com: $updates');
  }
}
