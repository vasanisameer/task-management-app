import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sameer_assigment/viewmodels/theme_manager.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeManagerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: currentTheme == ThemeMode.dark,
              onChanged: (value) {
                ThemeManager.toggleTheme(context, ref);
              },
            ),
          ),
        ],
      ),
    );
  }
}
