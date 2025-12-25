class OpeningHours {
  final String open;  // "09:00"
  final String close; // "22:00"
  
  OpeningHours({required this.open, required this.close});
  
  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    return OpeningHours(
      open: json['open'] ?? '09:00',
      close: json['close'] ?? '22:00',
    );
  }
  
  Map<String, dynamic> toJson() => {'open': open, 'close': close};
}

class Restaurant {
  final int id;
  final String name;
  final String cuisine;
  final String imageUrl;
  final double rating;
  final String address;
  final String phone;
  final int priceLevel;
  final String description;
  final Map<String, OpeningHours?> hours; // null = closed that day

  Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.imageUrl,
    required this.rating,
    required this.address,
    required this.phone,
    required this.priceLevel,
    required this.description,
    required this.hours,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    Map<String, OpeningHours?> parsedHours = {};
    if (json['hours'] != null) {
      (json['hours'] as Map<String, dynamic>).forEach((key, value) {
        parsedHours[key] = value != null ? OpeningHours.fromJson(value) : null;
      });
    }
    
    return Restaurant(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      cuisine: json['cuisine'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      priceLevel: json['priceLevel'] ?? 1,
      description: json['description'] ?? '',
      hours: parsedHours,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> hoursJson = {};
    hours.forEach((key, value) {
      hoursJson[key] = value?.toJson();
    });
    
    return {
      'id': id,
      'name': name,
      'cuisine': cuisine,
      'imageUrl': imageUrl,
      'rating': rating,
      'address': address,
      'phone': phone,
      'priceLevel': priceLevel,
      'description': description,
      'hours': hoursJson,
    };
  }

  String get priceLevelString => '\$' * priceLevel;
  
  // Get today's day name
  String get _todayName {
    final days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
    return days[DateTime.now().weekday % 7];
  }
  
  // Check if restaurant is currently open
  bool get isOpen {
    final today = _todayName;
    final todayHours = hours[today];
    
    if (todayHours == null) return false; // Closed today
    
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    
    final openParts = todayHours.open.split(':');
    final closeParts = todayHours.close.split(':');
    
    final openMinutes = int.parse(openParts[0]) * 60 + int.parse(openParts[1]);
    final closeMinutes = int.parse(closeParts[0]) * 60 + int.parse(closeParts[1]);
    
    return currentMinutes >= openMinutes && currentMinutes < closeMinutes;
  }
  
  // Get today's hours as string
  String get todayHoursString {
    final today = _todayName;
    final todayHours = hours[today];
    
    if (todayHours == null) return 'Closed today';
    return '${todayHours.open} - ${todayHours.close}';
  }
  
  // Get closing time info
  String get closingInfo {
    if (!isOpen) return 'Currently closed';
    
    final today = _todayName;
    final todayHours = hours[today];
    if (todayHours == null) return 'Closed';
    
    return 'Closes at ${todayHours.close}';
  }
  
  // Get opening time info
  String get openingInfo {
    if (isOpen) return 'Open now';
    
    final today = _todayName;
    final todayHours = hours[today];
    
    if (todayHours == null) {
      // Find next open day
      final days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
      final todayIndex = DateTime.now().weekday % 7;
      
      for (int i = 1; i <= 7; i++) {
        final nextIndex = (todayIndex + i) % 7;
        final nextDayHours = hours[days[nextIndex]];
        if (nextDayHours != null) {
          return 'Opens ${_capitalize(days[nextIndex])} at ${nextDayHours.open}';
        }
      }
      return 'Temporarily closed';
    }
    
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final openParts = todayHours.open.split(':');
    final openMinutes = int.parse(openParts[0]) * 60 + int.parse(openParts[1]);
    
    if (currentMinutes < openMinutes) {
      return 'Opens at ${todayHours.open}';
    }
    
    return 'Opens tomorrow';
  }
  
  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
