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
            // Title text
            const Text(
              'Welcome to FoodSpot',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.tealAccent, 
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Subtitle text
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
            
            // Button to navigate to the restaurant list screen
            ElevatedButton(
              onPressed: () {
                // Navigate to restaurant list screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantListScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.tealAccent, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Explore Restaurants',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black, 
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
