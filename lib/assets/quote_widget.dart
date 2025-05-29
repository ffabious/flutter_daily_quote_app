import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_daily_quote_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final appState = Provider.of<MyAppState>(context);
    final fontStyle = appState.fontStyle ?? FontStyle.normal;
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
          style: TextStyle(fontSize: 24, fontStyle: fontStyle),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
