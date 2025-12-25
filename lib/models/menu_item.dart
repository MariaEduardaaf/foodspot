class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final bool isPopular;
  final bool isVegetarian;
  final bool isSpicy;
  final List<String> allergens;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.isPopular = false,
    this.isVegetarian = false,
    this.isSpicy = false,
    this.allergens = const [],
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      isPopular: json['isPopular'] ?? false,
      isVegetarian: json['isVegetarian'] ?? false,
      isSpicy: json['isSpicy'] ?? false,
      allergens: List<String>.from(json['allergens'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isPopular': isPopular,
      'isVegetarian': isVegetarian,
      'isSpicy': isSpicy,
      'allergens': allergens,
    };
  }

  String get priceString => '\$${price.toStringAsFixed(2)}';
}

class MenuCategory {
  final String id;
  final String name;
  final String icon;
  final List<MenuItem> items;

  MenuCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.items,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      items: (json['items'] as List)
          .map((item) => MenuItem.fromJson(item))
          .toList(),
    );
  }
}

class RestaurantMenu {
  final int restaurantId;
  final List<MenuCategory> categories;

  RestaurantMenu({
    required this.restaurantId,
    required this.categories,
  });

  List<MenuItem> get allItems {
    return categories.expand((cat) => cat.items).toList();
  }

  List<MenuItem> get popularItems {
    return allItems.where((item) => item.isPopular).toList();
  }
}
