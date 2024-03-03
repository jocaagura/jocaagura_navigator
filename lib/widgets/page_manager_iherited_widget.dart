import 'package:flutter/material.dart';

import '../page_manager.dart';

class PageManagerInheritedWidget extends InheritedWidget {
  const PageManagerInheritedWidget({
    required this.pageManager,
    required super.child,
    super.key,
  });
  final PageManager pageManager;

  @override
  bool updateShouldNotify(PageManagerInheritedWidget oldWidget) {
    return pageManager != oldWidget.pageManager;
  }

  static PageManager of(BuildContext context) {
    final PageManagerInheritedWidget? result = context
        .dependOnInheritedWidgetOfExactType<PageManagerInheritedWidget>();
    assert(result != null, 'No PageManager found in context');
    return result!.pageManager;
  }
}
