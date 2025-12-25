enum ReservationStatus { pending, confirmed, cancelled, completed }

class Reservation {
  final String id;
  final int restaurantId;
  final String restaurantName;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final DateTime date;
  final String time;
  final int partySize;
  final String? specialRequests;
  final ReservationStatus status;
  final DateTime createdAt;

  Reservation({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.date,
    required this.time,
    required this.partySize,
    this.specialRequests,
    this.status = ReservationStatus.pending,
    required this.createdAt,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as int,
      restaurantName: json['restaurantName'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      customerEmail: json['customerEmail'] as String,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
      partySize: json['partySize'] as int,
      specialRequests: json['specialRequests'] as String?,
      status: ReservationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ReservationStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'date': date.toIso8601String(),
      'time': time,
      'partySize': partySize,
      'specialRequests': specialRequests,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Reservation copyWith({
    String? id,
    int? restaurantId,
    String? restaurantName,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    DateTime? date,
    String? time,
    int? partySize,
    String? specialRequests,
    ReservationStatus? status,
    DateTime? createdAt,
  }) {
    return Reservation(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      date: date ?? this.date,
      time: time ?? this.time,
      partySize: partySize ?? this.partySize,
      specialRequests: specialRequests ?? this.specialRequests,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get formattedDate {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return '${days[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}';
  }

  String get statusString {
    switch (status) {
      case ReservationStatus.pending:
        return 'Pending';
      case ReservationStatus.confirmed:
        return 'Confirmed';
      case ReservationStatus.cancelled:
        return 'Cancelled';
      case ReservationStatus.completed:
        return 'Completed';
    }
  }

  bool get isUpcoming {
    final now = DateTime.now();
    final reservationDateTime = DateTime(date.year, date.month, date.day);
    return reservationDateTime.isAfter(now.subtract(const Duration(days: 1))) &&
           status != ReservationStatus.cancelled;
  }
}
