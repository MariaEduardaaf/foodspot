import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

/// Sort options
enum SortOption { name, rating, price }

/// Provides an instance of the API service
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

/// Provider to fetch the list of restaurants
final restaurantProvider = FutureProvider<List<Restaurant>>((ref) async {
  return ref.read(apiServiceProvider).fetchRestaurants();
});

/// Provider that manages the search query state
final searchProvider = StateProvider<String>((ref) => '');

/// Provider that manages the selected cuisine filter
final cuisineFilterProvider = StateProvider<String?>((ref) => null);

/// Provider that manages the sort option
final sortOptionProvider = StateProvider<SortOption>((ref) => SortOption.rating);

/// Provider that returns all available cuisines
final availableCuisinesProvider = Provider<List<String>>((ref) {
  final restaurants = ref.watch(restaurantProvider).maybeWhen(
    data: (list) => list,
    orElse: () => <Restaurant>[],
  );
  
  final cuisines = restaurants.map((r) => r.cuisine).toSet().toList();
  cuisines.sort();
  return cuisines;
});

/// Provider that filters and sorts the restaurant list
final filteredRestaurantsProvider = Provider<List<Restaurant>>((ref) {
  final searchQuery = ref.watch(searchProvider).toLowerCase();
  final selectedCuisine = ref.watch(cuisineFilterProvider);
  final sortOption = ref.watch(sortOptionProvider);
  
  final restaurantList = ref.watch(restaurantProvider).maybeWhen(
    data: (restaurants) => restaurants.cast<Restaurant>(),
    orElse: () => <Restaurant>[],
  );

  // Filter
  var filtered = restaurantList.where((restaurant) {
    final matchesSearch = searchQuery.isEmpty || 
        restaurant.name.toLowerCase().contains(searchQuery);
    final matchesCuisine = selectedCuisine == null || 
        restaurant.cuisine == selectedCuisine;
    return matchesSearch && matchesCuisine;
  }).toList();

  // Sort
  switch (sortOption) {
    case SortOption.name:
      filtered.sort((a, b) => a.name.compareTo(b.name));
      break;
    case SortOption.rating:
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
      break;
    case SortOption.price:
      filtered.sort((a, b) => a.priceLevel.compareTo(b.priceLevel));
      break;
  }

  return filtered;
});
