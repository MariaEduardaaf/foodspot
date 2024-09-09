import 'package:flutter/material.dart';
import 'restaurant_list_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título chamativo
            const Text(
              'Welcome to FoodSpot',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.tealAccent,  // Cor destacada
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Texto complementar
            const Text(
              'Discover the best restaurants near you',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Botão para navegar para a tela de restaurantes
            ElevatedButton(
              onPressed: () {
                // Navega para a lista de restaurantes
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantListScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), backgroundColor: Colors.tealAccent,  // Cor do botão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Explore Restaurants',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,  // Texto contrastante
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
