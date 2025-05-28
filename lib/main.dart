import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_daily_quote_app/about_page.dart';
import 'package:flutter_daily_quote_app/my_home_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  runApp(const MyApp());
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

    return MaterialApp(
      title: "Quote of te Day",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.light,
      home: const CompletePage(),
    );
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

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var isDarkMode = false;

  void toggleIsDarkMode() {
    isDarkMode = !isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 0.8 * MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Settings",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.dark_mode),
                SizedBox(width: 10),
                Text("Dark Mode"),
                SizedBox(width: 10),
                Switch(
                  value: isDarkMode,
                  onChanged: (bool value) {
                    setState(() {
                      toggleIsDarkMode();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality to clear cache or reset settings
              },
              child: const Text("Reset Settings"),
            ),
          ],
        ),
      ),
    );
  }
}

class QuoteWidget extends StatelessWidget {
  const QuoteWidget({super.key});

  Future<String> fetchQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedQuote = prefs.getString('daily_quote');
    final lastFetchDate = prefs.getString('last_fetch_date');
    final today = DateTime.now().toIso8601String().split('T')[0];
    if (cachedQuote != null && lastFetchDate == today) {
      return cachedQuote;
    }

    final response = await http.get(
      Uri.parse('https://zenquotes.io/api/today'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final quote = '"${data[0]['q']}" - ${data[0]['a']}';
      await prefs.setString('daily_quote', quote);
      await prefs.setString('last_fetch_date', today);
      return quote;
    } else {
      throw Exception('Failed to load quote');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchQuote(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return Text(
          snapshot.data ?? 'No quote available',
          style: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
