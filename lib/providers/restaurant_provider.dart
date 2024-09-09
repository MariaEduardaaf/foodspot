import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/restaurant.dart';
import '../services/local_data_service.dart';

// Provider que carrega a lista de restaurantes
final restaurantProvider = FutureProvider<List<Restaurant>>((ref) async {
  return await LocalDataService().fetchRestaurants();
});

// Provider que controla o estado da barra de pesquisa
final searchProvider = StateProvider<String>((ref) => '');

// Provider que filtra a lista de restaurantes com base no termo de pesquisa
final filteredRestaurantsProvider = Provider<List<Restaurant>>((ref) {
  final searchQuery = ref.watch(searchProvider);
  final restaurantList = ref.watch(restaurantProvider).maybeWhen(
        data: (restaurants) => restaurants.cast<Restaurant>(),  // Forçando o tipo para List<Restaurant>
        orElse: () => <Restaurant>[],  // Garantindo que o tipo vazio seja List<Restaurant>
      );

  if (searchQuery.isEmpty) {
    return restaurantList;
  }

  return restaurantList
      .where((restaurant) =>
          restaurant.name.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();
});
