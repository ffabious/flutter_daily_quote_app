import 'package:flutter/material.dart';
import 'package:flutter_daily_quote_app/assets/my_app_state.dart';
import 'package:flutter_daily_quote_app/pages/about_page.dart';
import 'package:flutter_daily_quote_app/pages/my_home_page.dart';
import 'package:flutter_daily_quote_app/pages/settings_page.dart';
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
      title: "Quote of the Day",
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: appState.themeMode,
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
        currentPage = FavoritesPage(key: ValueKey('favorites'));
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

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context);
    return Center(
      child: SizedBox(
        width: 0.8 * MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: appState.likedQuotes.length,
          itemBuilder: (context, index) {
            final quote = appState.likedQuotes[index];
            return Card(
              child: ListTile(
                title: Text(
                  quote,
                  style: TextStyle(fontSize: 18, fontStyle: appState.fontStyle),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    appState.unlikeQuote(quote);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
