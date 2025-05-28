import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Quote of te Day",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
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
        currentPage = const MyHomePage();
        break;
      case 1:
        currentPage = const Center(child: Text("Favorites Page"));
        break;
      case 2:
        currentPage = const Center(child: Text("Settings Page"));
        break;
      case 3:
        currentPage = const Center(child: Text("About Page"));
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
      body: currentPage,
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 0.8 * MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '"'
              "We can't retract the decisions we've made. "
              "We can only affect the decisions we're going to make from here."
              '"',
              style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  label: const Text('Like'),
                  icon: const Icon(Icons.favorite_border),
                  iconAlignment: IconAlignment.start,
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next Quote'),
                  iconAlignment: IconAlignment.start,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
