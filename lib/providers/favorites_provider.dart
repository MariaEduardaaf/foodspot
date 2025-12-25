import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesNotifier extends StateNotifier<Set<int>> {
  FavoritesNotifier() : super({}) {
    _loadFavorites();
  }

  static const String _key = 'favorite_restaurants';

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList(_key) ?? [];
    state = favoriteIds.map((id) => int.parse(id)).toSet();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, state.map((id) => id.toString()).toList());
  }

  void toggleFavorite(int restaurantId) {
    if (state.contains(restaurantId)) {
      state = {...state}..remove(restaurantId);
    } else {
      state = {...state, restaurantId};
    }
    _saveFavorites();
  }

  bool isFavorite(int restaurantId) {
    return state.contains(restaurantId);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<int>>(
  (ref) => FavoritesNotifier(),
);
