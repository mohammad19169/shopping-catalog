import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_project/providers/product_provider.dart';
import 'package:ecommerce_project/repositories/product_repository.dart';
import 'package:ecommerce_project/screens/main_screen.dart';
import 'package:ecommerce_project/services/api_service.dart';
import 'package:ecommerce_project/services/local_storage_service.dart';

void main() {
  runApp(const MyApp());
}

class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        Provider(create: (_) => LocalStorageService()),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(
            productRepository: ProductRepository(
              apiService: context.read<ApiService>(),
              localStorageService: context.read<LocalStorageService>(),
            ),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'Ecommerce App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.light(
                primary: const Color(0xFF6C63FF),
                secondary: const Color(0xFFF8B400),
                surface: Colors.white,
                background: const Color(0xFFF5F5F5),
                error: const Color(0xFFE74C3C),
                onPrimary: Colors.white,
                onSecondary: Colors.black,
                onSurface: Colors.black,
                onBackground: Colors.black,
                onError: Colors.white,
                brightness: Brightness.light,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF6C63FF),
                elevation: 0,
                centerTitle: true,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              cardTheme: CardThemeData(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.zero,
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.dark(
                primary: const Color(0xFF8B7CF6),
                secondary: const Color(0xFFFF8CB3),
                surface: const Color(0xFF1E1E1E),
                background: const Color(0xFF121212),
                error: const Color(0xFFE74C3C),
                onPrimary: Colors.black,
                onSecondary: Colors.black,
                onSurface: Colors.white,
                onBackground: Colors.white,
                onError: Colors.black,
                brightness: Brightness.dark,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF1E1E1E),
                elevation: 0,
                centerTitle: true,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              cardTheme: CardThemeData(
                color: const Color(0xFF2D2D2D),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.zero,
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
