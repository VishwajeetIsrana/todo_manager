import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'core/services/local_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/todo_provider.dart';
import 'routes/app_routes.dart';
import 'services/todo_api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = LocalStorageService();
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  final apiService = TodoApiService(dio);

  await GoogleFonts.pendingFonts([
    GoogleFonts.plusJakartaSans(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        Provider<LocalStorageService>.value(value: storage),
        Provider<TodoApiService>.value(value: apiService),
        ChangeNotifierProvider(
          create: (_) => TodoProvider(apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(storage)..loadTheme(),
        ),
      ],
      child: const TodoManagerApp(),
    ),
  );
}

class TodoManagerApp extends StatelessWidget {
  const TodoManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, themeProvider, __) {
        return MaterialApp(
          title: 'Todo Manager',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.generateRoute,
        );
      },
    );
  }
}
