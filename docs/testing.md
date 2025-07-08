# Testing Documentation

## Testing Strategy
This project follows Test-Driven Development (TDD) principles with comprehensive test coverage.

## Test Types

### 1. Unit Tests
- **Location**: `test/unit/`
- **Purpose**: Test individual components in isolation
- **Coverage**: 
  - Domain entities (AnxietyEntry)
  - Use cases (CRUD operations)
  - Repository implementations
  - Data models

### 2. Widget Tests
- **Location**: `test/widget/`
- **Purpose**: Test UI components and user interactions
- **Coverage**:
  - Individual widgets
  - Page components
  - Form validation
  - State management

### 3. Integration Tests
- **Location**: `test/integration/`
- **Purpose**: Test complete user workflows
- **Scenarios**:
  - Adding a new anxiety entry
  - Viewing entry history
  - Exporting data
  - Navigation between screens

## Test Structure

### Domain Layer Tests
```dart
// Example: AnxietyEntry entity tests
test('should create an instance with all required properties', () {
  // Arrange
  final entry = AnxietyEntry(/* ... */);
  
  // Act & Assert
  expect(entry.id, equals('1'));
  expect(entry.trigger, equals('Work presentation'));
});
```

### Use Case Tests
```dart
// Example: CreateEntry use case tests
test('should create entry successfully', () async {
  // Arrange
  when(mockRepository.createEntry(any))
      .thenAnswer((_) async => testEntry);
  
  // Act
  final result = await useCase(testEntry);
  
  // Assert
  expect(result, equals(testEntry));
});
```

### Widget Tests
```dart
// Example: Add Entry form tests
testWidgets('should show validation error for empty trigger', (tester) async {
  // Arrange
  await tester.pumpWidget(/* ... */);
  
  // Act
  await tester.tap(find.text('Save Entry'));
  await tester.pump();
  
  // Assert
  expect(find.text('Please enter a trigger'), findsOneWidget);
});
```

## Test Dependencies
- **flutter_test**: Flutter testing framework
- **mockito**: Mocking framework for unit tests
- **build_runner**: Code generation for mocks

## Running Tests

### All Tests
```bash
flutter test
```

### Unit Tests Only
```bash
flutter test test/unit/
```

### Widget Tests Only
```bash
flutter test test/widget/
```

### Integration Tests Only
```bash
flutter test test/integration/
```

### Coverage Report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Test Best Practices

### 1. AAA Pattern
- **Arrange**: Set up test data and dependencies
- **Act**: Execute the functionality being tested
- **Assert**: Verify the expected outcomes

### 2. Test Naming
- Use descriptive test names
- Follow pattern: `should_ExpectedBehavior_When_StateUnderTest`

### 3. Mock Usage
- Mock external dependencies
- Verify interactions with mocks
- Use realistic test data

### 4. Test Coverage
- Aim for 80%+ code coverage
- Focus on business logic coverage
- Test edge cases and error scenarios

## Continuous Integration
- Tests run automatically on every commit
- Pre-commit hooks ensure code quality
- Coverage reports generated for each build

## Example Test Files
- `test/unit/features/entry/domain/entities/anxiety_entry_test.dart`
- `test/unit/features/entry/domain/usecases/create_entry_test.dart`
- `test/widget/features/entry/presentation/pages/add_entry_page_test.dart`
- `test/integration/add_entry_flow_test.dart`