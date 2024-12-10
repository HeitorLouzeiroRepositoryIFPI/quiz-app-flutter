import 'package:flutter/material.dart';
import 'package:quizz_app_flutter/features/timepage/select_time_age.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SelectTimePage(),
    );
  }
}
