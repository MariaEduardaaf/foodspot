import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/restaurant_provider.dart';
import '../models/restaurant.dart';
import 'restaurant_details_screen.dart';

class RestaurantListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurants = ref.watch(filteredRestaurantsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants'),
        iconTheme: IconThemeData(color: Colors.white),  // Ícones brancos
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Restaurants',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                ref.read(searchProvider.notifier).state = value;
              },
            ),
          ),
          Expanded(
            child: restaurants.isEmpty
                ? Center(
                    child: Text(
                      'No restaurants found.',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final Restaurant restaurant = restaurants[index];

                      // Define o caminho da imagem com base no nome do restaurante
                      String imagePath;
                      switch (restaurant.name) {
                        case "The Smokehouse":
                          imagePath = 'assets/images/meat-platter-perfect.jpg';
                          break;
                        case "Pinocchio\'s Pizza":
                          imagePath = 'assets/images/pizza-pinocchio.jpeg';
                          break;
                        case "Felipe\'s Taqueria":
                          imagePath = 'assets/images/taqueria.jpeg';
                          break;
                        case "Tasty Burger":
                          imagePath = 'assets/images/burguer.jpeg';
                          break;
                        default:
                          imagePath = 'assets/images/default.jpg';
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.grey[900],
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(15),
                            leading: Hero(
                              tag: 'restaurant-${restaurant.id}',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  imagePath,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              restaurant.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              restaurant.cuisine,
                              style: TextStyle(color: Colors.grey),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                            onTap: () {
                              // Navegação para a tela de detalhes com o caminho da imagem
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RestaurantDetailsScreen(
                                    restaurant: restaurant,
                                    imagePath: imagePath,  // Passando o caminho da imagem
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
