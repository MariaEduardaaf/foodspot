import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

/// Provides an instance of the API service
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

/// Provider to fetch the list of restaurants
final restaurantProvider = FutureProvider<List<Restaurant>>((ref) async {
  return ref.read(apiServiceProvider).fetchRestaurants();
});

/// Provider that manages the search query state
final searchProvider = StateProvider<String>((ref) => '');

/// Provider that filters the restaurant list based on the search query
final filteredRestaurantsProvider = Provider<List<Restaurant>>((ref) {
  final searchQuery = ref.watch(searchProvider).toLowerCase();
  final restaurantList = ref.watch(restaurantProvider).maybeWhen(
    data: (restaurants) => restaurants.cast<Restaurant>(), // Ensure the correct type
    orElse: () => <Restaurant>[], // Fallback to an empty list if data is not available
  );

  if (searchQuery.isEmpty) {
    return restaurantList;
  }

  // Filter the restaurant list by name based on the search query
  return restaurantList.where((restaurant) {
    return restaurant.name.toLowerCase().contains(searchQuery);
  }).toList();
});
