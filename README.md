# FoodSpot

**FoodSpot** is a Flutter application designed to help users discover and explore restaurants near them. The app features a simple yet effective user interface that displays a list of restaurants with images, and allows users to filter restaurants by name using a search bar.

## Features

- List of restaurants with images and cuisine types.
- Search functionality to filter restaurants by name.
- State management using **Riverpod**.
- Responsive design using Flutter's Material widgets.
- Clean UI with **Google Fonts** integration.

## Project Structure

This project uses Flutter with the following libraries:

- **Flutter Riverpod**: For state management.
- **Google Fonts**: To apply custom fonts (Poppins family).
- **Cupertino Icons**: For iOS-style icons.

## Getting Started

### Prerequisites

Make sure you have Flutter installed on your machine. If not, follow the official installation guide:

- [Flutter Installation](https://docs.flutter.dev/get-started/install)

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/MariaEduardaaf/foodspot.git
   ```
   
2. Navigate to the project directory:
   ```
   cd foodspot
   ```

3. Install the dependencies:
   ```
   flutter pub get
   ```

4. Run the application:
   ```
   flutter run
   ```

### Folder Structure

- `lib/`: Contains the main code of the app.
  - `models/`: Contains the `Restaurant` model.
  - `screens/`: Includes the UI screens such as `HomeScreen`, `RestaurantListScreen`, and `RestaurantDetailsScreen`.
  - `services/`: Contains the `LocalDataService` and `ApiService` for handling data.
  - `providers/`: State management using Riverpod.

### Assets

The app uses several images for restaurant listings:

- `assets/images/meat-platter-perfect.jpg`
- `assets/images/pizza-pinocchio.jpeg`
- `assets/images/taqueria.jpeg`
- `assets/images/burguer.jpeg`

### Fonts

The app uses the **Poppins** font family, included in the assets directory:
- `Poppins-Regular.ttf`
- `Poppins-Bold.ttf`

## How to Contribute

If you'd like to contribute to this project, feel free to submit a pull request. Please follow these steps:

1. Fork the repository.
2. Create a new branch:
   ```
   git checkout -b feature/your-feature
   ```
3. Make your changes and commit them:
   ```
   git commit -m "Add your message here"
   ```
4. Push to your branch:
   ```
   git push origin feature/your-feature
   ```
5. Create a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
