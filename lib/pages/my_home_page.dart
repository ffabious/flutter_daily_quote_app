import 'package:flutter/material.dart';
import 'package:flutter_daily_quote_app/assets/quote_widget.dart';
import 'package:flutter_daily_quote_app/assets/quote_countdown.dart';
import 'package:flutter_daily_quote_app/assets/my_app_state.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var isLiked = false;
  void toggleLike() {
    var appState = Provider.of<MyAppState>(context, listen: false);
    appState.toggleLike();
    isLiked = appState.isLiked;
    if (isLiked) {
      appState.likeQuote(appState.dailyQuote);
    } else {
      appState.unlikeQuote(appState.dailyQuote);
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context);
    isLiked = appState.isLiked;
    var icon = isLiked
        ? const Icon(Icons.favorite)
        : const Icon(Icons.favorite_border);

    return Center(
      child: SizedBox(
        width: 0.8 * MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            QuoteWidget(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  toggleLike();
                });
              },
              label: const Text('Like'),
              icon: icon,
              iconAlignment: IconAlignment.start,
            ),
            const SizedBox(height: 20),
            const QuoteCountdown(),
          ],
        ),
      ),
    );
  }
}
