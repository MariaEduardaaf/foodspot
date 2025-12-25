import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reservation.dart';

class ReservationsNotifier extends StateNotifier<List<Reservation>> {
  ReservationsNotifier() : super([]) {
    _loadReservations();
  }

  static const String _storageKey = 'user_reservations';

  Future<void> _loadReservations() async {
    final prefs = await SharedPreferences.getInstance();
    final reservationsJson = prefs.getString(_storageKey);
    
    if (reservationsJson != null) {
      final List<dynamic> decoded = json.decode(reservationsJson);
      state = decoded
          .map((r) => Reservation.fromJson(r as Map<String, dynamic>))
          .toList();
    }
  }

  Future<void> _saveReservations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.map((r) => r.toJson()).toList();
    await prefs.setString(_storageKey, json.encode(jsonList));
  }

  Future<void> addReservation({
    required int restaurantId,
    required String restaurantName,
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required DateTime date,
    required String time,
    required int partySize,
    String? specialRequests,
  }) async {
    final reservation = Reservation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      customerName: customerName,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
      date: date,
      time: time,
      partySize: partySize,
      specialRequests: specialRequests,
      status: ReservationStatus.confirmed,
      createdAt: DateTime.now(),
    );

    state = [reservation, ...state];
    await _saveReservations();
  }

  Future<void> cancelReservation(String id) async {
    state = state.map((r) {
      if (r.id == id) {
        return r.copyWith(status: ReservationStatus.cancelled);
      }
      return r;
    }).toList();
    await _saveReservations();
  }

  Future<void> deleteReservation(String id) async {
    state = state.where((r) => r.id != id).toList();
    await _saveReservations();
  }

  List<Reservation> getUpcomingReservations() {
    return state.where((r) => r.isUpcoming).toList();
  }

  List<Reservation> getPastReservations() {
    return state.where((r) => !r.isUpcoming).toList();
  }

  List<Reservation> getReservationsForRestaurant(int restaurantId) {
    return state.where((r) => r.restaurantId == restaurantId).toList();
  }
}

final reservationsProvider = StateNotifierProvider<ReservationsNotifier, List<Reservation>>((ref) {
  return ReservationsNotifier();
});

final upcomingReservationsProvider = Provider<List<Reservation>>((ref) {
  final reservations = ref.watch(reservationsProvider);
  return reservations.where((r) => r.isUpcoming).toList();
});

final pastReservationsProvider = Provider<List<Reservation>>((ref) {
  final reservations = ref.watch(reservationsProvider);
  return reservations.where((r) => !r.isUpcoming).toList();
});
