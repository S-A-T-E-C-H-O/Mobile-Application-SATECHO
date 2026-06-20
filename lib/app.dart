import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

class AgrosafeApp extends StatelessWidget {
  const AgrosafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AGROSAFE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _ApplicationShell(),
    );
  }
}

class _ApplicationShell extends StatelessWidget {
  const _ApplicationShell();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox.shrink());
  }
}
