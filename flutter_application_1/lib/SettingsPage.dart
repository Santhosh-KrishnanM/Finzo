import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) toggleTheme;

  const SettingsPage(
      {super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(value: isDarkMode, onChanged: toggleTheme),
          ),
          const Divider(),
          ListTile(
            title: const Text('About'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('About'),
                    content:
                        const Text('This is a sample Flutter application.'),
                    actions: [
                      TextButton(
                          child: const Text('Close'),
                          onPressed: () => Navigator.pop(context))
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
