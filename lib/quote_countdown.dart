import 'package:flutter/material.dart';
import 'dart:async';

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
