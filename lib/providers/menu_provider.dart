import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_item.dart';

class MenuNotifier extends StateNotifier<Map<int, RestaurantMenu>> {
  MenuNotifier() : super({}) {
    _loadMockMenus();
  }

  void _loadMockMenus() {
    state = {
      // 1: The Smokehouse (BBQ)
      1: RestaurantMenu(
        restaurantId: 1,
        categories: [
          MenuCategory(id: 'starters', name: 'Starters', icon: 'appetizer', items: [
            MenuItem(id: '1-1', name: 'Loaded Nachos', description: 'Crispy tortilla chips with melted cheese, jalapenos, sour cream', price: 12.99, isPopular: true),
            MenuItem(id: '1-2', name: 'BBQ Wings', description: '8 pieces of crispy wings tossed in our signature BBQ sauce', price: 14.99, isSpicy: true),
            MenuItem(id: '1-3', name: 'Onion Rings', description: 'Beer-battered onion rings with ranch dipping sauce', price: 8.99, isVegetarian: true),
          ]),
          MenuCategory(id: 'mains', name: 'Main Courses', icon: 'main', items: [
            MenuItem(id: '1-4', name: 'Smoked Brisket', description: '14-hour smoked beef brisket with two sides', price: 24.99, isPopular: true),
            MenuItem(id: '1-5', name: 'Baby Back Ribs', description: 'Full rack of tender ribs glazed with hickory BBQ sauce', price: 28.99, isPopular: true),
            MenuItem(id: '1-6', name: 'Pulled Pork Sandwich', description: 'Slow-smoked pulled pork on brioche bun with coleslaw', price: 16.99),
            MenuItem(id: '1-7', name: 'BBQ Combo Platter', description: 'Brisket, ribs, pulled pork and sausage with three sides', price: 39.99),
          ]),
          MenuCategory(id: 'sides', name: 'Sides', icon: 'sides', items: [
            MenuItem(id: '1-8', name: 'Mac & Cheese', description: 'Creamy three-cheese macaroni', price: 6.99, isVegetarian: true),
            MenuItem(id: '1-9', name: 'Coleslaw', description: 'Fresh cabbage slaw with creamy dressing', price: 4.99, isVegetarian: true),
            MenuItem(id: '1-10', name: 'Baked Beans', description: 'Slow-cooked beans with bacon bits', price: 5.99),
          ]),
          MenuCategory(id: 'drinks', name: 'Drinks', icon: 'drinks', items: [
            MenuItem(id: '1-11', name: 'Sweet Tea', description: 'Southern-style sweet iced tea', price: 3.49, isVegetarian: true),
            MenuItem(id: '1-12', name: 'Craft Beer', description: 'Selection of local craft beers', price: 6.99),
          ]),
        ],
      ),
      
      // 2: Sakura Sushi (Japanese)
      2: RestaurantMenu(
        restaurantId: 2,
        categories: [
          MenuCategory(id: 'starters', name: 'Starters', icon: 'appetizer', items: [
            MenuItem(id: '2-1', name: 'Edamame', description: 'Steamed soybeans with sea salt', price: 5.99, isVegetarian: true),
            MenuItem(id: '2-2', name: 'Miso Soup', description: 'Traditional miso soup with tofu and seaweed', price: 4.99, isVegetarian: true),
            MenuItem(id: '2-3', name: 'Gyoza', description: 'Pan-fried pork dumplings (6 pcs)', price: 8.99, isPopular: true),
          ]),
          MenuCategory(id: 'sushi', name: 'Sushi Rolls', icon: 'main', items: [
            MenuItem(id: '2-4', name: 'California Roll', description: 'Crab, avocado, cucumber (8 pcs)', price: 12.99),
            MenuItem(id: '2-5', name: 'Spicy Tuna Roll', description: 'Fresh tuna with spicy mayo (8 pcs)', price: 14.99, isSpicy: true, isPopular: true),
            MenuItem(id: '2-6', name: 'Dragon Roll', description: 'Eel, avocado, cucumber topped with avocado (8 pcs)', price: 18.99, isPopular: true),
            MenuItem(id: '2-7', name: 'Rainbow Roll', description: 'California roll topped with assorted sashimi', price: 19.99),
            MenuItem(id: '2-8', name: 'Vegetable Roll', description: 'Cucumber, avocado, carrot (8 pcs)', price: 10.99, isVegetarian: true),
          ]),
          MenuCategory(id: 'sashimi', name: 'Sashimi', icon: 'sashimi', items: [
            MenuItem(id: '2-9', name: 'Salmon Sashimi', description: 'Fresh Atlantic salmon (5 pcs)', price: 16.99),
            MenuItem(id: '2-10', name: 'Tuna Sashimi', description: 'Premium bluefin tuna (5 pcs)', price: 18.99),
            MenuItem(id: '2-11', name: 'Sashimi Deluxe', description: 'Chef selection of 15 pieces', price: 34.99, isPopular: true),
          ]),
          MenuCategory(id: 'drinks', name: 'Drinks', icon: 'drinks', items: [
            MenuItem(id: '2-12', name: 'Green Tea', description: 'Hot Japanese green tea', price: 2.99, isVegetarian: true),
            MenuItem(id: '2-13', name: 'Sake', description: 'Premium Japanese sake', price: 9.99),
          ]),
        ],
      ),
      
      // 3: Taco Fiesta (Mexican)
      3: RestaurantMenu(
        restaurantId: 3,
        categories: [
          MenuCategory(id: 'starters', name: 'Starters', icon: 'appetizer', items: [
            MenuItem(id: '3-1', name: 'Chips & Guacamole', description: 'Fresh-made guacamole with tortilla chips', price: 8.99, isVegetarian: true, isPopular: true),
            MenuItem(id: '3-2', name: 'Queso Fundido', description: 'Melted cheese with chorizo', price: 10.99),
            MenuItem(id: '3-3', name: 'Nachos Supreme', description: 'Loaded nachos with all toppings', price: 12.99),
          ]),
          MenuCategory(id: 'tacos', name: 'Tacos', icon: 'main', items: [
            MenuItem(id: '3-4', name: 'Carnitas Tacos', description: 'Slow-cooked pork with onions and cilantro (3 pcs)', price: 12.99, isPopular: true),
            MenuItem(id: '3-5', name: 'Carne Asada Tacos', description: 'Grilled steak with pico de gallo (3 pcs)', price: 14.99, isPopular: true),
            MenuItem(id: '3-6', name: 'Fish Tacos', description: 'Beer-battered fish with cabbage slaw (3 pcs)', price: 13.99),
            MenuItem(id: '3-7', name: 'Veggie Tacos', description: 'Grilled vegetables with black beans (3 pcs)', price: 11.99, isVegetarian: true),
          ]),
          MenuCategory(id: 'burritos', name: 'Burritos', icon: 'burrito', items: [
            MenuItem(id: '3-8', name: 'Chicken Burrito', description: 'Grilled chicken, rice, beans, cheese, sour cream', price: 13.99),
            MenuItem(id: '3-9', name: 'Steak Burrito', description: 'Carne asada, rice, beans, guacamole', price: 15.99, isPopular: true),
          ]),
          MenuCategory(id: 'drinks', name: 'Drinks', icon: 'drinks', items: [
            MenuItem(id: '3-10', name: 'Horchata', description: 'Traditional rice drink with cinnamon', price: 3.99, isVegetarian: true),
            MenuItem(id: '3-11', name: 'Margarita', description: 'Classic lime margarita', price: 9.99, isPopular: true),
          ]),
        ],
      ),
      
      // 4: La Bella Italia (Italian)
      4: RestaurantMenu(
        restaurantId: 4,
        categories: [
          MenuCategory(id: 'antipasti', name: 'Antipasti', icon: 'appetizer', items: [
            MenuItem(id: '4-1', name: 'Bruschetta', description: 'Toasted bread with tomatoes, garlic, and basil', price: 9.99, isVegetarian: true, isPopular: true),
            MenuItem(id: '4-2', name: 'Caprese Salad', description: 'Fresh mozzarella, tomatoes, basil with balsamic', price: 12.99, isVegetarian: true),
            MenuItem(id: '4-3', name: 'Calamari Fritti', description: 'Crispy fried calamari with marinara sauce', price: 14.99),
          ]),
          MenuCategory(id: 'pasta', name: 'Pasta', icon: 'main', items: [
            MenuItem(id: '4-4', name: 'Spaghetti Carbonara', description: 'Classic carbonara with pancetta and egg', price: 18.99, isPopular: true),
            MenuItem(id: '4-5', name: 'Fettuccine Alfredo', description: 'Creamy parmesan sauce with fettuccine', price: 17.99, isVegetarian: true),
            MenuItem(id: '4-6', name: 'Penne Arrabbiata', description: 'Spicy tomato sauce with garlic', price: 15.99, isVegetarian: true, isSpicy: true),
            MenuItem(id: '4-7', name: 'Lasagna Bolognese', description: 'Layers of pasta, meat sauce, and bechamel', price: 19.99, isPopular: true),
          ]),
          MenuCategory(id: 'pizza', name: 'Pizza', icon: 'pizza', items: [
            MenuItem(id: '4-8', name: 'Margherita', description: 'Tomato, mozzarella, fresh basil', price: 16.99, isVegetarian: true, isPopular: true),
            MenuItem(id: '4-9', name: 'Pepperoni', description: 'Classic pepperoni with mozzarella', price: 18.99),
            MenuItem(id: '4-10', name: 'Quattro Formaggi', description: 'Four cheese pizza', price: 19.99, isVegetarian: true),
          ]),
          MenuCategory(id: 'desserts', name: 'Dolci', icon: 'dessert', items: [
            MenuItem(id: '4-11', name: 'Tiramisu', description: 'Classic Italian coffee-flavored dessert', price: 8.99, isVegetarian: true, isPopular: true),
            MenuItem(id: '4-12', name: 'Panna Cotta', description: 'Creamy vanilla panna cotta with berry sauce', price: 7.99, isVegetarian: true),
          ]),
        ],
      ),
      
      // 5: Dragon Palace (Chinese)
      5: RestaurantMenu(
        restaurantId: 5,
        categories: [
          MenuCategory(id: 'starters', name: 'Starters', icon: 'appetizer', items: [
            MenuItem(id: '5-1', name: 'Spring Rolls', description: 'Crispy vegetable spring rolls (4 pcs)', price: 6.99, isVegetarian: true),
            MenuItem(id: '5-2', name: 'Potstickers', description: 'Pan-fried pork dumplings (6 pcs)', price: 8.99, isPopular: true),
            MenuItem(id: '5-3', name: 'Hot & Sour Soup', description: 'Traditional spicy and sour soup', price: 5.99, isSpicy: true),
          ]),
          MenuCategory(id: 'mains', name: 'Main Courses', icon: 'main', items: [
            MenuItem(id: '5-4', name: 'Kung Pao Chicken', description: 'Spicy chicken with peanuts and vegetables', price: 15.99, isSpicy: true, isPopular: true),
            MenuItem(id: '5-5', name: 'Sweet & Sour Pork', description: 'Crispy pork in sweet and sour sauce', price: 14.99),
            MenuItem(id: '5-6', name: 'Beef with Broccoli', description: 'Tender beef with fresh broccoli', price: 16.99, isPopular: true),
            MenuItem(id: '5-7', name: 'General Tsos Chicken', description: 'Crispy chicken in spicy sweet sauce', price: 15.99, isSpicy: true),
            MenuItem(id: '5-8', name: 'Vegetable Lo Mein', description: 'Stir-fried noodles with vegetables', price: 12.99, isVegetarian: true),
          ]),
          MenuCategory(id: 'dimsum', name: 'Dim Sum', icon: 'dimsum', items: [
            MenuItem(id: '5-9', name: 'Har Gow', description: 'Shrimp dumplings (4 pcs)', price: 7.99),
            MenuItem(id: '5-10', name: 'Siu Mai', description: 'Pork and shrimp dumplings (4 pcs)', price: 7.99, isPopular: true),
            MenuItem(id: '5-11', name: 'Char Siu Bao', description: 'BBQ pork buns (3 pcs)', price: 6.99),
          ]),
          MenuCategory(id: 'drinks', name: 'Drinks', icon: 'drinks', items: [
            MenuItem(id: '5-12', name: 'Jasmine Tea', description: 'Traditional Chinese jasmine tea', price: 2.99, isVegetarian: true),
            MenuItem(id: '5-13', name: 'Tsingtao Beer', description: 'Chinese lager beer', price: 5.99),
          ]),
        ],
      ),
      
      // 6: Burger Joint (American)
      6: RestaurantMenu(
        restaurantId: 6,
        categories: [
          MenuCategory(id: 'starters', name: 'Starters', icon: 'appetizer', items: [
            MenuItem(id: '6-1', name: 'French Fries', description: 'Crispy golden fries with sea salt', price: 4.99, isVegetarian: true),
            MenuItem(id: '6-2', name: 'Cheese Fries', description: 'Fries topped with melted cheese and bacon', price: 7.99, isPopular: true),
            MenuItem(id: '6-3', name: 'Onion Rings', description: 'Beer-battered onion rings', price: 6.99, isVegetarian: true),
          ]),
          MenuCategory(id: 'burgers', name: 'Burgers', icon: 'main', items: [
            MenuItem(id: '6-4', name: 'Classic Burger', description: 'Beef patty, lettuce, tomato, onion, pickles', price: 10.99),
            MenuItem(id: '6-5', name: 'Cheeseburger', description: 'Classic burger with American cheese', price: 11.99, isPopular: true),
            MenuItem(id: '6-6', name: 'Bacon Cheeseburger', description: 'Cheeseburger with crispy bacon', price: 13.99, isPopular: true),
            MenuItem(id: '6-7', name: 'Double Burger', description: 'Two beef patties with cheese', price: 15.99),
            MenuItem(id: '6-8', name: 'Veggie Burger', description: 'Plant-based patty with all the fixings', price: 12.99, isVegetarian: true),
          ]),
          MenuCategory(id: 'shakes', name: 'Milkshakes', icon: 'drinks', items: [
            MenuItem(id: '6-9', name: 'Vanilla Shake', description: 'Creamy vanilla milkshake', price: 5.99, isVegetarian: true),
            MenuItem(id: '6-10', name: 'Chocolate Shake', description: 'Rich chocolate milkshake', price: 5.99, isVegetarian: true, isPopular: true),
            MenuItem(id: '6-11', name: 'Oreo Shake', description: 'Vanilla shake with Oreo cookies', price: 6.99, isVegetarian: true),
          ]),
        ],
      ),
      
      // 7: Spice Route (Indian)
      7: RestaurantMenu(
        restaurantId: 7,
        categories: [
          MenuCategory(id: 'starters', name: 'Starters', icon: 'appetizer', items: [
            MenuItem(id: '7-1', name: 'Samosas', description: 'Crispy pastries filled with spiced potatoes (2 pcs)', price: 6.99, isVegetarian: true, isPopular: true),
            MenuItem(id: '7-2', name: 'Pakoras', description: 'Vegetable fritters with mint chutney', price: 7.99, isVegetarian: true),
            MenuItem(id: '7-3', name: 'Chicken Tikka', description: 'Marinated chicken pieces grilled in tandoor', price: 12.99),
          ]),
          MenuCategory(id: 'curries', name: 'Curries', icon: 'main', items: [
            MenuItem(id: '7-4', name: 'Butter Chicken', description: 'Tender chicken in creamy tomato sauce', price: 17.99, isPopular: true),
            MenuItem(id: '7-5', name: 'Lamb Rogan Josh', description: 'Slow-cooked lamb in aromatic spices', price: 19.99),
            MenuItem(id: '7-6', name: 'Chicken Tikka Masala', description: 'Grilled chicken in spiced curry sauce', price: 18.99, isPopular: true),
            MenuItem(id: '7-7', name: 'Palak Paneer', description: 'Spinach curry with cottage cheese', price: 15.99, isVegetarian: true),
            MenuItem(id: '7-8', name: 'Vindaloo', description: 'Very spicy curry with potatoes', price: 17.99, isSpicy: true),
          ]),
          MenuCategory(id: 'breads', name: 'Breads', icon: 'bread', items: [
            MenuItem(id: '7-9', name: 'Naan', description: 'Traditional Indian bread', price: 3.99, isVegetarian: true),
            MenuItem(id: '7-10', name: 'Garlic Naan', description: 'Naan with garlic and butter', price: 4.99, isVegetarian: true, isPopular: true),
            MenuItem(id: '7-11', name: 'Roti', description: 'Whole wheat bread', price: 2.99, isVegetarian: true),
          ]),
          MenuCategory(id: 'drinks', name: 'Drinks', icon: 'drinks', items: [
            MenuItem(id: '7-12', name: 'Mango Lassi', description: 'Sweet mango yogurt drink', price: 4.99, isVegetarian: true, isPopular: true),
            MenuItem(id: '7-13', name: 'Masala Chai', description: 'Spiced Indian tea', price: 3.49, isVegetarian: true),
          ]),
        ],
      ),
      
      // 8: Mediterranean Grill
      8: RestaurantMenu(
        restaurantId: 8,
        categories: [
          MenuCategory(id: 'starters', name: 'Starters', icon: 'appetizer', items: [
            MenuItem(id: '8-1', name: 'Hummus', description: 'Creamy chickpea dip with pita bread', price: 8.99, isVegetarian: true, isPopular: true),
            MenuItem(id: '8-2', name: 'Falafel', description: 'Crispy chickpea fritters (6 pcs)', price: 9.99, isVegetarian: true),
            MenuItem(id: '8-3', name: 'Greek Salad', description: 'Tomatoes, cucumber, olives, feta cheese', price: 11.99, isVegetarian: true),
          ]),
          MenuCategory(id: 'mains', name: 'Main Courses', icon: 'main', items: [
            MenuItem(id: '8-4', name: 'Chicken Shawarma', description: 'Marinated chicken with garlic sauce', price: 16.99, isPopular: true),
            MenuItem(id: '8-5', name: 'Lamb Kebab', description: 'Grilled lamb skewers with rice', price: 19.99),
            MenuItem(id: '8-6', name: 'Gyro Plate', description: 'Sliced gyro meat with tzatziki', price: 17.99, isPopular: true),
            MenuItem(id: '8-7', name: 'Grilled Fish', description: 'Mediterranean sea bass with vegetables', price: 22.99),
            MenuItem(id: '8-8', name: 'Vegetable Moussaka', description: 'Layered eggplant and potato casserole', price: 15.99, isVegetarian: true),
          ]),
          MenuCategory(id: 'wraps', name: 'Wraps', icon: 'wrap', items: [
            MenuItem(id: '8-9', name: 'Chicken Wrap', description: 'Grilled chicken with vegetables in pita', price: 12.99),
            MenuItem(id: '8-10', name: 'Falafel Wrap', description: 'Falafel with hummus and vegetables', price: 11.99, isVegetarian: true, isPopular: true),
          ]),
          MenuCategory(id: 'drinks', name: 'Drinks', icon: 'drinks', items: [
            MenuItem(id: '8-11', name: 'Turkish Coffee', description: 'Strong traditional coffee', price: 3.99, isVegetarian: true),
            MenuItem(id: '8-12', name: 'Fresh Lemonade', description: 'Freshly squeezed with mint', price: 4.49, isVegetarian: true),
          ]),
        ],
      ),
    };
  }

  RestaurantMenu? getMenuForRestaurant(int restaurantId) {
    return state[restaurantId];
  }
}

final menuProvider = StateNotifierProvider<MenuNotifier, Map<int, RestaurantMenu>>((ref) {
  return MenuNotifier();
});

final restaurantMenuProvider = Provider.family<RestaurantMenu?, int>((ref, restaurantId) {
  final menus = ref.watch(menuProvider);
  return menus[restaurantId];
});
