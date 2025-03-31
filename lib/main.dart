import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/products_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/delivery_screen.dart';
import 'screens/splash_screen.dart';
import 'themes/app_themes.dart';
import 'themes/theme_provider.dart';
import 'configs/app_config.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// Провайдер для выбранного индекса в навигации
final selectedIndexProvider = StateProvider<int>((ref) => 0);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp(
      title: AppConfig.appName,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const MainScreen(),
        '/about': (context) => const AboutScreen(),
        '/products': (context) => const ProductsScreen(),
        '/contact': (context) => const ContactScreen(),
        '/delivery': (context) => const DeliveryScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends ConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ProductsScreen(),
    const AboutScreen(),
    const ContactScreen(),
    const DeliveryScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final themeState = ref.watch(themeProvider);

    return Scaffold(
      body: RepaintBoundary(
        child: _widgetOptions[selectedIndex],
      ),
      bottomNavigationBar: RepaintBoundary(
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: 'Продукция',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'О компании',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_phone),
              label: 'Контакты',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping),
              label: 'Доставка',
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          onTap: (index) =>
              ref.read(selectedIndexProvider.notifier).state = index,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(themeProvider).changeTheme(!themeState.isDarkMode);
        },
        child: Icon(
          themeState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
        ),
        tooltip: themeState.isDarkMode
            ? 'Включить светлую тему'
            : 'Включить темную тему',
      ),
    );
  }
}
