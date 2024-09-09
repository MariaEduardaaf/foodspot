import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

// Instância do serviço de API
final apiServiceProvider = Provider((ref) => ApiService());

// Provider que carrega a lista de restaurantes
final restaurantProvider = FutureProvider<List<Restaurant>>((ref) async {
  return await ref.read(apiServiceProvider).fetchRestaurants();
});

// Provider que controla o estado da barra de pesquisa
final searchProvider = StateProvider<String>((ref) => '');

// Provider que filtra a lista de restaurantes com base no termo de pesquisa
final filteredRestaurantsProvider = Provider<List<Restaurant>>((ref) {
  final searchQuery = ref.watch(searchProvider);
  final restaurantList = ref.watch(restaurantProvider).maybeWhen(
        data: (restaurants) => restaurants.cast<Restaurant>(),
        orElse: () => <Restaurant>[],
      );

  if (searchQuery.isEmpty) {
    return restaurantList;
  }

  return restaurantList
      .where((restaurant) =>
          restaurant.name.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();
});
