import 'package:flutter/material.dart';

import '../custom_page.dart';

class Page404Page extends StatelessWidget {
  const Page404Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: Navigator.of(context).pop,
          child: const Text(
            'Page not found',
          ),
        ),
      ),
    );
  }
}

const CustomPage page404Page = CustomPage(
  child: Page404Page(),
  title: 'Page not found',
  routeName: '/not-found',
);
