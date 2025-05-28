import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
