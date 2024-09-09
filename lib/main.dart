import 'package:flutter/material.dart';
import 'screens/restaurant_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodSpot',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: RestaurantListScreen(),
    );
  }
}
