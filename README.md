# Anxiety Tracker

A Flutter mobile application for tracking anxiety episodes and monitoring progress over time.

## Features

🏠 **Home Dashboard** - Overview of recent activity and weekly statistics
📝 **Entry Tracking** - Record anxiety episodes with detailed information
📊 **Data Analysis** - Visual insights with charts and pattern recognition
📋 **History Management** - View and manage all past entries
💾 **Data Export** - Export data to CSV/JSON formats
🔒 **Privacy First** - All data stored locally on device

## Architecture

This project follows **Clean Architecture** principles with **MVVM** pattern:

- **Presentation Layer**: Flutter widgets, Riverpod state management
- **Domain Layer**: Business logic, entities, use cases
- **Data Layer**: Local storage with Hive database

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate code:
   ```bash
   flutter packages pub run build_runner build
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/                 # Core utilities and base classes
├── features/             # Feature-based modules
│   ├── entry/           # Anxiety entry management
│   ├── home/            # Home dashboard
│   ├── history/         # Entry history
│   ├── analysis/        # Data analysis
│   └── profile/         # User profile & export
├── presentation/        # Shared UI components
└── main.dart           # App entry point
```

## Dependencies

- **flutter_riverpod**: State management
- **hive**: Local database
- **fl_chart**: Charts and graphs
- **intl**: Date/time formatting
- **csv**: Data export

## Testing

Run tests with:
```bash
flutter test
```

Test coverage:
```bash
flutter test --coverage
```

## Development Guidelines

- Follow Clean Architecture principles
- Write tests before implementation (TDD)
- Use Riverpod for state management
- Maintain SOLID principles
- Follow Flutter best practices

## Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for new features
4. Ensure all tests pass
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For issues and questions, please create an issue in the GitHub repository.