# Architecture Documentation

## Overview
This Flutter application follows Clean Architecture principles with MVVM pattern for anxiety disorder tracking.

## Architecture Layers

### 1. Presentation Layer
- **Location**: `lib/features/*/presentation/`
- **Responsibilities**: UI components, state management, user interactions
- **Components**:
  - Pages (Views)
  - Widgets (Reusable UI components)
  - Providers (Riverpod state management)

### 2. Domain Layer
- **Location**: `lib/features/*/domain/`
- **Responsibilities**: Business logic, entities, use cases
- **Components**:
  - Entities (Core business objects)
  - Repositories (Abstract interfaces)
  - Use Cases (Business logic operations)

### 3. Data Layer
- **Location**: `lib/features/*/data/`
- **Responsibilities**: Data access, external APIs, local storage
- **Components**:
  - Models (Data transfer objects)
  - Repositories (Concrete implementations)
  - Data Sources (Local/Remote data access)

## MVVM Pattern Implementation

### View
- Flutter widgets and pages
- Observe state changes from ViewModels
- Handle user interactions

### ViewModel
- Implemented using Riverpod StateNotifier
- Manage UI state and business logic
- Communicate with Use Cases

### Model
- Domain entities represent business objects
- Data models for persistence and data transfer

## State Management
- **Framework**: Riverpod
- **Pattern**: Provider pattern with dependency injection
- **Benefits**: Reactive programming, easy testing, clear separation of concerns

## Dependencies Direction
```
Presentation → Domain ← Data
```

- Presentation depends on Domain
- Data depends on Domain
- Domain has no dependencies (pure business logic)

## Key Features
- Clean separation of concerns
- Testable architecture
- Scalable structure
- Dependency injection
- Reactive state management