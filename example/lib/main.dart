import 'package:example/pages/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:jocaagura_navigator/jocaagura_navigator.dart';

void main() {
  runApp(const MyApp());
}

bool setHome = true;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final JocaaguraNavigator jocaaguraNavigator = JocaaguraNavigator(
        ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        'Navigator Demo');

    if (setHome) {
      Future<void>.delayed(const Duration(milliseconds: 2000), () {
        jocaaguraNavigator.set404Page(
          const CustomPage(
              child: MyHomePage(
                title: 'Hola mundo',
              ),
              title: 'Home Page',
              routeName: '/'),
        );
      });
      jocaaguraNavigator.update();
      setHome = false;
    }

    return jocaaguraNavigator.myApp();
  }
}
