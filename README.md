# Todo Manager

A production-quality Flutter task management application built with Clean Architecture and Provider state management.

## Features

- Splash screen with smooth animations
- Dummy authentication with persistent login state
- Fetch todos from REST API (JSONPlaceholder)
- Real-time search with debouncing (300ms)
- Filter by completion status
- Pull-to-refresh
- Add, edit, delete todos (local)
- Toggle task completion via checkbox
- Swipe-to-delete with confirmation dialog
- Dark mode support (persisted)
- Material 3 design
- Responsive UI
- Error handling with retry
- Empty state illustrations
- Snackbars for all CRUD actions

## Folder Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/    # App-wide constants
│   ├── theme/        # Material 3 light/dark themes
│   ├── services/     # LocalStorage (SharedPreferences)
│   └── utils/        # Debouncer utility
├── models/           # TodoModel
├── providers/        # TodoProvider, ThemeProvider
├── services/         # TodoApiService (Dio)
├── screens/
│   ├── splash/       # Animated splash screen
│   ├── login/        # Login with validation
│   ├── home/         # Main todo list screen
│   └── add_edit/     # Add/Edit todo screen
├── widgets/          # Reusable widgets
└── routes/           # Named route generator
```

## Packages Used

| Package             | Purpose                       |
|---------------------|-------------------------------|
| provider            | State management              |
| dio                 | HTTP client for REST API      |
| shared_preferences  | Local persistence             |
| flutter/material3   | UI framework                  |

## How to Run

```bash
flutter pub get
flutter run
```

## Dummy Login Credentials

| Field    | Value          |
|----------|----------------|
| Email    | admin@gmail.com |
| Password | 123456          |

## Architecture

This project follows Clean Architecture principles adapted for Flutter:

1. **Presentation Layer** — Screens and widgets (UI only, no business logic)
2. **Provider Layer** — ChangeNotifier classes that manage state and orchestrate business logic
3. **Service Layer** — Data sources (API via Dio, local via SharedPreferences)
4. **Model Layer** — Data models with fromJson/toJson serialization
5. **Core Layer** — Shared utilities, constants, and theme configuration

Data flows unidirectionally: UI → Provider → Service → API/Storage
