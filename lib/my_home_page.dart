import 'package:flutter/material.dart';
import 'package:flutter_daily_quote_app/main.dart';
import 'package:flutter_daily_quote_app/quote_countdown.dart';

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
