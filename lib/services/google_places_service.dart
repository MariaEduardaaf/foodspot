import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';

class GooglePlacesService {
  static const String _apiKey = 'YOUR_API_KEY_HERE';
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  Future<List<Restaurant>> searchNearbyRestaurants({
    required double latitude,
    required double longitude,
    int radius = 1500,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=restaurant&key=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List<dynamic>;
      return results.map((place) => _parsePlace(place)).toList();
    } else {
      throw Exception('Failed to fetch restaurants');
    }
  }

  Future<List<Restaurant>> searchRestaurants(String query) async {
    final url = Uri.parse(
      '$_baseUrl/textsearch/json?query=$query+restaurants&key=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List<dynamic>;
      return results.map((place) => _parsePlace(place)).toList();
    } else {
      throw Exception('Failed to search restaurants');
    }
  }

  String getPhotoUrl(String photoReference, {int maxWidth = 400}) {
    return '$_baseUrl/photo?maxwidth=$maxWidth&photo_reference=$photoReference&key=$_apiKey';
  }

  Restaurant _parsePlace(Map<String, dynamic> place) {
    String imageUrl = '';
    if (place['photos'] != null && (place['photos'] as List).isNotEmpty) {
      final photoRef = place['photos'][0]['photo_reference'];
      imageUrl = getPhotoUrl(photoRef);
    }

    String cuisine = 'Restaurant';
    if (place['types'] != null) {
      final types = place['types'] as List;
      if (types.contains('cafe')) cuisine = 'Cafe';
      if (types.contains('bakery')) cuisine = 'Bakery';
      if (types.contains('bar')) cuisine = 'Bar';
    }

    // Default hours (we don't have detailed hours from basic API)
    Map<String, OpeningHours?> defaultHours = {
      'monday': OpeningHours(open: '09:00', close: '22:00'),
      'tuesday': OpeningHours(open: '09:00', close: '22:00'),
      'wednesday': OpeningHours(open: '09:00', close: '22:00'),
      'thursday': OpeningHours(open: '09:00', close: '22:00'),
      'friday': OpeningHours(open: '09:00', close: '23:00'),
      'saturday': OpeningHours(open: '10:00', close: '23:00'),
      'sunday': OpeningHours(open: '10:00', close: '21:00'),
    };

    return Restaurant(
      id: place['place_id'].hashCode,
      name: place['name'] ?? '',
      cuisine: cuisine,
      imageUrl: imageUrl,
      rating: (place['rating'] ?? 0.0).toDouble(),
      address: place['formatted_address'] ?? place['vicinity'] ?? '',
      phone: place['formatted_phone_number'] ?? '',
      priceLevel: place['price_level'] ?? 1,
      description: '',
      hours: defaultHours,
    );
  }
}
