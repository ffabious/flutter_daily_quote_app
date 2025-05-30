import 'package:flutter/material.dart';
import 'package:flutter_daily_quote_app/assets/my_app_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final appState = Provider.of<MyAppState>(context);
    isDarkMode = appState.themeMode == ThemeMode.dark;

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
            SizedBox(
              width: 0.3 * MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.dark_mode),
                      SizedBox(width: 10),
                      Text("Dark Mode"),
                    ],
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: (bool value) {
                      setState(() {
                        appState.toggleDarkMode(value);
                        toggleIsDarkMode();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 0.3 * MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.format_italic),
                      SizedBox(width: 10),
                      Text("Italic Font"),
                    ],
                  ),
                  Switch(
                    value: appState.fontStyle == FontStyle.italic,
                    onChanged: (bool value) {
                      setState(() {
                        appState.toggleItalicStyle(value);
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  appState.toggleDarkMode(false);
                  appState.toggleItalicStyle(false);
                  isDarkMode = false;
                });
                final prefs = SharedPreferences.getInstance();
                prefs.then((preferences) {
                  preferences.setBool('isDarkMode', false);
                  preferences.setBool('isItalic', false);
                });
              },
              child: const Text("Reset Settings"),
            ),
          ],
        ),
      ),
    );
  }
}
