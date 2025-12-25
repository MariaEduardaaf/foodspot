import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/visit.dart';

class VisitsNotifier extends StateNotifier<List<Visit>> {
  VisitsNotifier() : super([]) {
    _loadVisits();
  }

  static const String _storageKey = 'restaurant_visits';

  Future<void> _loadVisits() async {
    final prefs = await SharedPreferences.getInstance();
    final visitsJson = prefs.getString(_storageKey);
    
    if (visitsJson != null) {
      final List<dynamic> decoded = json.decode(visitsJson);
      state = decoded
          .map((v) => Visit.fromJson(v as Map<String, dynamic>))
          .toList();
    }
  }

  Future<void> _saveVisits() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.map((v) => v.toJson()).toList();
    await prefs.setString(_storageKey, json.encode(jsonList));
  }

  Future<void> addVisit({
    required int restaurantId,
    required String restaurantName,
    required String restaurantCuisine,
    required String restaurantImageUrl,
    DateTime? visitDate,
    String? notes,
    double? rating,
  }) async {
    final visit = Visit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      restaurantCuisine: restaurantCuisine,
      restaurantImageUrl: restaurantImageUrl,
      visitDate: visitDate ?? DateTime.now(),
      notes: notes,
      rating: rating,
    );

    state = [visit, ...state];
    await _saveVisits();
  }

  Future<void> removeVisit(String id) async {
    state = state.where((v) => v.id != id).toList();
    await _saveVisits();
  }

  bool hasVisited(int restaurantId) {
    return state.any((v) => v.restaurantId == restaurantId);
  }

  int visitCount(int restaurantId) {
    return state.where((v) => v.restaurantId == restaurantId).length;
  }

  Visit? lastVisit(int restaurantId) {
    final visits = state.where((v) => v.restaurantId == restaurantId).toList();
    if (visits.isEmpty) return null;
    visits.sort((a, b) => b.visitDate.compareTo(a.visitDate));
    return visits.first;
  }

  List<Visit> getVisitsForRestaurant(int restaurantId) {
    return state.where((v) => v.restaurantId == restaurantId).toList();
  }
}

final visitsProvider = StateNotifierProvider<VisitsNotifier, List<Visit>>((ref) {
  return VisitsNotifier();
});

final hasVisitedProvider = Provider.family<bool, int>((ref, restaurantId) {
  final visits = ref.watch(visitsProvider);
  return visits.any((v) => v.restaurantId == restaurantId);
});

final visitCountProvider = Provider.family<int, int>((ref, restaurantId) {
  final visits = ref.watch(visitsProvider);
  return visits.where((v) => v.restaurantId == restaurantId).length;
});
