import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sameer_assigment/services/hive_service.dart';
import 'package:sameer_assigment/views/task_list_screen.dart';
import 'package:sameer_assigment/viewmodels/theme_manager.dart';
import './views/add_edit_task_view.dart';
import './views/settings_view.dart';

void main() async {
  await Hive.initFlutter();
  await HiveService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appTheme = ref.watch(themeManagerProvider);

        return MaterialApp(
          title: 'Task Management App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: appTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => const TaskListScreen(),
            '/add_edit_task': (context) => const AddEditTaskView(),
            '/settings': (context) => const SettingsView(),
          },
        );
      },
    );
  }
}
