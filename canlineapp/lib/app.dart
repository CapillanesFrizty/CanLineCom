import 'package:flutter/material.dart';
import 'Routes/goRoute.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: linkrouter,
    );
  }
}
