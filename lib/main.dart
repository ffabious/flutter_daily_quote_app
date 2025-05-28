import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
        currentPage = AboutPage();
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

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'About Quote of the Day',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'This app provides a new quote every day to inspire and motivate you.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'GitHub Repo: ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(width: 8),
                Tooltip(
                  message: 'Visit GitHub Repository',
                  waitDuration: const Duration(milliseconds: 500),
                  child: ElevatedButton(
                    onPressed: () async {
                      final Uri url = Uri.parse(
                        'https://github.com/ffabious/flutter_daily_quote_app',
                      );
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Text(
                      'GitHub Repo',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Powered by: ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(width: 8),
                Tooltip(
                  message: 'Visit ZenQuotes API',
                  waitDuration: const Duration(milliseconds: 500),
                  child: ElevatedButton(
                    onPressed: () async {
                      final Uri url = Uri.parse('https://zenquotes.io/');
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Text(
                      'ZenQuotes',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Developed by: ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(width: 8),
                Tooltip(
                  message: 'Visit GitHub Profile',
                  waitDuration: const Duration(milliseconds: 500),
                  child: ElevatedButton(
                    onPressed: () async {
                      final Uri url = Uri.parse('https://github.com/ffabious');
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Text(
                      'ffabious',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
            QuoteWidget(),
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
            const SizedBox(height: 20),
            const QuoteCountdown(),
          ],
        ),
      ),
    );
  }
}

class QuoteCountdown extends StatefulWidget {
  const QuoteCountdown({super.key});

  @override
  State<QuoteCountdown> createState() => _QuoteCountdownState();
}

class _QuoteCountdownState extends State<QuoteCountdown> {
  late Duration _remaining;
  late Timer _timer;

  Duration timeUntilMidnight() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    return midnight.difference(now);
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _remaining = _remaining - Duration(seconds: 1);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _remaining = timeUntilMidnight();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Next quote in: ${_formatDuration(_remaining)}',
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class QuoteWidget extends StatelessWidget {
  const QuoteWidget({super.key});

  Future<String> fetchQuote() async {
    final response = await http.get(
      Uri.parse('https://zenquotes.io/api/today'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final quote = '"${data[0]['q']}" - ${data[0]['a']}';
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
