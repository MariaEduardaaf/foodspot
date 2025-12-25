import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/review.dart';

class ReviewsNotifier extends StateNotifier<Map<int, List<Review>>> {
  ReviewsNotifier() : super({}) {
    _loadReviews();
  }

  static const String _storageKey = 'restaurant_reviews';

  Future<void> _loadReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final reviewsJson = prefs.getString(_storageKey);
    
    if (reviewsJson != null) {
      final Map<String, dynamic> decoded = json.decode(reviewsJson);
      final Map<int, List<Review>> reviews = {};
      
      decoded.forEach((key, value) {
        final restaurantId = int.parse(key);
        final reviewList = (value as List)
            .map((r) => Review.fromJson(r as Map<String, dynamic>))
            .toList();
        reviews[restaurantId] = reviewList;
      });
      
      state = reviews;
    } else {
      // Add some mock reviews
      _addMockReviews();
    }
  }

  void _addMockReviews() {
    state = {
      1: [
        Review(
          id: '1',
          restaurantId: 1,
          userName: 'John D.',
          rating: 5.0,
          comment: 'Amazing food and great atmosphere! The pasta was perfectly cooked.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Review(
          id: '2',
          restaurantId: 1,
          userName: 'Sarah M.',
          rating: 4.0,
          comment: 'Good service, tasty dishes. A bit pricey but worth it.',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ],
      2: [
        Review(
          id: '3',
          restaurantId: 2,
          userName: 'Mike R.',
          rating: 5.0,
          comment: 'Best sushi in town! Fresh ingredients and creative rolls.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      3: [
        Review(
          id: '4',
          restaurantId: 3,
          userName: 'Emily W.',
          rating: 4.5,
          comment: 'Authentic Mexican flavors. The tacos are incredible!',
          createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        ),
      ],
    };
    _saveReviews();
  }

  Future<void> _saveReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> toSave = {};
    
    state.forEach((key, value) {
      toSave[key.toString()] = value.map((r) => r.toJson()).toList();
    });
    
    await prefs.setString(_storageKey, json.encode(toSave));
  }

  Future<void> addReview({
    required int restaurantId,
    required String userName,
    required double rating,
    required String comment,
  }) async {
    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      restaurantId: restaurantId,
      userName: userName,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );

    final currentReviews = state[restaurantId] ?? [];
    state = {
      ...state,
      restaurantId: [review, ...currentReviews],
    };
    
    await _saveReviews();
  }

  List<Review> getReviewsForRestaurant(int restaurantId) {
    return state[restaurantId] ?? [];
  }

  double getAverageRating(int restaurantId) {
    final reviews = state[restaurantId] ?? [];
    if (reviews.isEmpty) return 0.0;
    
    final sum = reviews.fold<double>(0, (sum, r) => sum + r.rating);
    return sum / reviews.length;
  }

  int getReviewCount(int restaurantId) {
    return (state[restaurantId] ?? []).length;
  }
}

final reviewsProvider = StateNotifierProvider<ReviewsNotifier, Map<int, List<Review>>>((ref) {
  return ReviewsNotifier();
});

// Provider to get reviews for a specific restaurant
final restaurantReviewsProvider = Provider.family<List<Review>, int>((ref, restaurantId) {
  final allReviews = ref.watch(reviewsProvider);
  return allReviews[restaurantId] ?? [];
});

// Provider to get average rating for a specific restaurant
final restaurantAverageRatingProvider = Provider.family<double, int>((ref, restaurantId) {
  final reviews = ref.watch(restaurantReviewsProvider(restaurantId));
  if (reviews.isEmpty) return 0.0;
  
  final sum = reviews.fold<double>(0, (sum, r) => sum + r.rating);
  return sum / reviews.length;
});
