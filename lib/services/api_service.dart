import '../models/restaurant.dart';

class ApiService {
  Future<List<Restaurant>> fetchRestaurants() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      Restaurant(
        id: 1,
        name: "The Smokehouse",
        cuisine: "Barbecue",
        imageUrl: "assets/images/meat-platter-perfect.jpg",
        rating: 4.5,
        address: "123 Main Street, Boston, MA",
        phone: "+1 (617) 555-0101",
        priceLevel: 2,
        description: "Authentic smokehouse serving slow-cooked meats and classic BBQ sides. Our brisket is smoked for 14 hours.",
        hours: {
          'monday': OpeningHours(open: '11:00', close: '22:00'),
          'tuesday': OpeningHours(open: '11:00', close: '22:00'),
          'wednesday': OpeningHours(open: '11:00', close: '22:00'),
          'thursday': OpeningHours(open: '11:00', close: '23:00'),
          'friday': OpeningHours(open: '11:00', close: '23:00'),
          'saturday': OpeningHours(open: '10:00', close: '23:00'),
          'sunday': OpeningHours(open: '10:00', close: '21:00'),
        },
      ),
      Restaurant(
        id: 2,
        name: "Pinocchio's Pizza",
        cuisine: "Italian",
        imageUrl: "assets/images/pizza-pinocchio.jpeg",
        rating: 4.8,
        address: "74 Winthrop St, Cambridge, MA",
        phone: "+1 (617) 555-0102",
        priceLevel: 1,
        description: "Famous Harvard Square pizzeria known for its Sicilian slices since 1966.",
        hours: {
          'monday': OpeningHours(open: '11:00', close: '24:00'),
          'tuesday': OpeningHours(open: '11:00', close: '24:00'),
          'wednesday': OpeningHours(open: '11:00', close: '24:00'),
          'thursday': OpeningHours(open: '11:00', close: '24:00'),
          'friday': OpeningHours(open: '11:00', close: '02:00'),
          'saturday': OpeningHours(open: '11:00', close: '02:00'),
          'sunday': OpeningHours(open: '12:00', close: '23:00'),
        },
      ),
      Restaurant(
        id: 3,
        name: "Felipe's Taqueria",
        cuisine: "Mexican",
        imageUrl: "assets/images/taqueria.jpeg",
        rating: 4.3,
        address: "21 Brattle St, Cambridge, MA",
        phone: "+1 (617) 555-0103",
        priceLevel: 1,
        description: "Fresh Mexican cuisine with made-to-order burritos, tacos, and refreshing margaritas.",
        hours: {
          'monday': null, // Closed on Mondays
          'tuesday': OpeningHours(open: '11:00', close: '22:00'),
          'wednesday': OpeningHours(open: '11:00', close: '22:00'),
          'thursday': OpeningHours(open: '11:00', close: '22:00'),
          'friday': OpeningHours(open: '11:00', close: '24:00'),
          'saturday': OpeningHours(open: '10:00', close: '24:00'),
          'sunday': OpeningHours(open: '10:00', close: '21:00'),
        },
      ),
      Restaurant(
        id: 4,
        name: "Tasty Burger",
        cuisine: "American",
        imageUrl: "assets/images/burguer.jpeg",
        rating: 4.1,
        address: "40 JFK St, Cambridge, MA",
        phone: "+1 (617) 555-0104",
        priceLevel: 1,
        description: "Gourmet burgers made with fresh, locally sourced ingredients.",
        hours: {
          'monday': OpeningHours(open: '11:00', close: '23:00'),
          'tuesday': OpeningHours(open: '11:00', close: '23:00'),
          'wednesday': OpeningHours(open: '11:00', close: '23:00'),
          'thursday': OpeningHours(open: '11:00', close: '23:00'),
          'friday': OpeningHours(open: '11:00', close: '02:00'),
          'saturday': OpeningHours(open: '11:00', close: '02:00'),
          'sunday': OpeningHours(open: '12:00', close: '22:00'),
        },
      ),
    ];
  }
}
