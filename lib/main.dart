import 'package:flutter/material.dart';
import 'package:shuttle_shuffle/core/theme/app_theme.dart';
import 'core/di/injection_container.dart' as di;

import 'features/player/presentation/pages/player_input_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shuttle Shuffle',
      theme: AppTheme.darkTheme,
      home: const PlayerInputPage(),
    );
  }
}
