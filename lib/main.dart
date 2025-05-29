import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_daily_quote_app/pages/about_page.dart';
import 'package:flutter_daily_quote_app/pages/my_home_page.dart';
import 'package:flutter_daily_quote_app/pages/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitle("ffabious' Quote of the Day");
      await windowManager.setSize(const Size(800, 600));
      await windowManager.center();
      await windowManager.show();
      await windowManager.focus();
    });

    var lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
    );
    var darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
    );

    final appState = Provider.of<MyAppState>(context);

    return MaterialApp(
      title: "Quote of te Day",
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: appState.themeMode,
      home: const CompletePage(),
    );
  }
}

class MyAppState extends ChangeNotifier {
  ThemeMode? themeMode;
  FontStyle? fontStyle;

  MyAppState() {
    _loadInitState();
  }

  Future<void> _loadInitState() async {
    final prefs = await SharedPreferences.getInstance();

    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;

    final isItalic = prefs.getBool('isItalic') ?? false;
    fontStyle = isItalic ? FontStyle.italic : FontStyle.normal;

    notifyListeners();
  }

  void toggleDarkMode(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = SharedPreferences.getInstance();
    prefs.then((preferences) {
      preferences.setBool('isDarkMode', isDark);
    });
    notifyListeners();
  }

  void toggleItalicStyle(bool isItalic) {
    fontStyle = isItalic ? FontStyle.italic : FontStyle.normal;
    final prefs = SharedPreferences.getInstance();
    prefs.then((preferences) {
      preferences.setBool('isItalic', isItalic);
    });
    notifyListeners();
  }
}

class CompletePage extends StatefulWidget {
  const CompletePage({super.key});

  @override
  State<CompletePage> createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {
  int selectedIndex = 0;
  Widget currentPage = const MyHomePage();

  void updatePage(int index) {
    switch (index) {
      case 0:
        currentPage = const MyHomePage(key: ValueKey('home'));
        break;
      case 1:
        currentPage = const Center(
          key: ValueKey('favorites'),
          child: Text("Favorites Page"),
        );
        break;
      case 2:
        currentPage = const SettingsPage(key: ValueKey('settings'));
        break;
      case 3:
        currentPage = const AboutPage(key: ValueKey('about'));
        break;
      default:
        throw UnimplementedError("No page for index $index");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quote of the Day"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 100),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: currentPage,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            updatePage(index);
          });
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
