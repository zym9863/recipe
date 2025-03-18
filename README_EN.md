# Recipe App

[中文](README.md) | English

A feature-rich Flutter recipe application that provides detailed cooking steps and ingredient lists.

## Features

- **Recipe Browsing**: Browse various recipes by category
- **Recipe Details**: View detailed ingredient lists and cooking steps
- **Favorites**: Save favorite recipes for later reference
- **Search Function**: Search recipes by dish name or ingredients
- **Settings**: Customize application settings

## Technical Architecture

### Frontend
- **Flutter Framework**: Cross-platform UI built with Flutter
- **Material Design**: Following Material Design guidelines
- **State Management**: Using StatefulWidget for component state management

### Backend Integration
- **API Integration**: Support for Spoonacular API integration for more recipes
- **Local Data**: Built-in traditional Chinese recipe data

## Project Structure

```
lib/
  ├── config/         # Configuration files
  ├── models/         # Data models
  ├── screens/        # Application screens
  ├── services/       # Service layer
  ├── widgets/        # Reusable components
  └── main.dart       # Application entry
```

## Recipe Categories

The application includes various Chinese cuisine styles:
- Sichuan Cuisine (e.g., Mapo Tofu, Twice-Cooked Pork)
- Cantonese Cuisine (e.g., White Cut Chicken, Stir-fried Eggs with Shrimp)
- Shandong Cuisine (e.g., Sweet and Sour Carp)
- Other regional specialties

## Installation Guide

### Prerequisites
- Flutter SDK (^3.7.2)
- Dart SDK
- Android Studio / Xcode (for running emulators)

### Installation Steps

1. Clone the project locally
   ```
   git clone https://github.com/zym9863/recipe.git
   ```

2. Enter the project directory
   ```
   cd recipe
   ```

3. Install dependencies
   ```
   flutter pub get
   ```

4. Run the application
   ```
   flutter run
   ```

## API Configuration

This application supports integration with the Spoonacular API. To use the online recipe feature, follow these steps:

1. Register at [Spoonacular](https://spoonacular.com/food-api) and obtain an API key
2. Enter your API key in the application settings

## Dependencies

- flutter: sdk
- http: ^1.3.0 - For API requests
- google_fonts: ^6.2.1 - For custom fonts
- cupertino_icons: ^1.0.8 - iOS style icons

## Development Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [Material Design Guidelines](https://material.io/design)

## Contribution Guidelines

Contributions of code, issue reports, or new feature suggestions are welcome. Please follow these steps:

1. Fork the project
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Create a Pull Request