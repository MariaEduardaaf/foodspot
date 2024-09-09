import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/restaurant_list_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodSpot',
      theme: ThemeData(
        primaryColor: Colors.black, // Preto como cor principal
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.tealAccent, // Acento em verde menta ou outra cor moderna
          brightness: Brightness.dark,  // Define o tema escuro
        ),
        scaffoldBackgroundColor: Colors.black, // Fundo preto
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.grey, fontSize: 14), // Texto com cinza suave
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.black,  // AppBar preta
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.tealAccent, // Botões com acento em verde menta
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: RestaurantListScreen(),
    );
  }
}
