class Visit {
  final String id;
  final int restaurantId;
  final String restaurantName;
  final String restaurantCuisine;
  final String restaurantImageUrl;
  final DateTime visitDate;
  final String? notes;
  final double? rating;

  Visit({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantCuisine,
    required this.restaurantImageUrl,
    required this.visitDate,
    this.notes,
    this.rating,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as int,
      restaurantName: json['restaurantName'] as String,
      restaurantCuisine: json['restaurantCuisine'] as String,
      restaurantImageUrl: json['restaurantImageUrl'] as String,
      visitDate: DateTime.parse(json['visitDate'] as String),
      notes: json['notes'] as String?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'restaurantCuisine': restaurantCuisine,
      'restaurantImageUrl': restaurantImageUrl,
      'visitDate': visitDate.toIso8601String(),
      'notes': notes,
      'rating': rating,
    };
  }

  String get formattedDate {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[visitDate.month - 1]} ${visitDate.day}, ${visitDate.year}';
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(visitDate);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
}
