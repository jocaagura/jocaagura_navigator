import 'package:flutter/material.dart';

import 'custom_page.dart';
import 'my_app_route_delegate.dart';
import 'page_manager.dart';
import 'route_information_parser.dart';
import 'widgets/page_manager_iherited_widget.dart';

export 'custom_page.dart';

final PageManager _pageManager = PageManager();

class JocaaguraNavigator {
  const JocaaguraNavigator(
    this.themeData,
    this.appTitle,
  );
  final ThemeData themeData;
  final String appTitle;

  Widget myApp() {
    final MyAppRouteInformationParser routeInformationParser =
        MyAppRouteInformationParser(_pageManager);
    final MyAppRouterDelegate routerDelegate =
        MyAppRouterDelegate(_pageManager);
    return PageManagerInheritedWidget(
      pageManager: _pageManager,
      child: MaterialApp.router(
        theme: themeData,
        title: appTitle,
        routerDelegate: routerDelegate,
        routeInformationParser: routeInformationParser,
      ),
    );
  }

  void set404Page(CustomPage customPage) {
    _pageManager.set404Page(customPage);
  }

  void setHomePage(CustomPage customPage) {
    _pageManager.setHomePage(customPage);
  }

  void push(CustomPage customPage) {
    _pageManager.push(customPage);
  }

  void update() {
    _pageManager.update();
  }

  void pushNamed(String routeName) {
    _pageManager.pushNamed(routeName);
  }

  void pushNamedAndReplacement(String routeName) {
    _pageManager.pushNamedAndReplacement(routeName);
  }

  void pushFromRoutesettings(
    String routeName,
    CustomPage routeSettings,
  ) {
    _pageManager.pushFromRoutesettings(routeName, routeSettings);
  }

  void back() {
    _pageManager.back();
  }

  RouteInformation? getCurrentUrl() {
    return _pageManager.getCurrentUrl();
  }

  void clearHistory() {
    _pageManager.clearHistory();
  }

  bool isThisRouteNameInDirectory(String routeName) {
    return _pageManager.isThisRouteNameInDirectory(routeName);
  }

  int get historyPagesCount => _pageManager.historyPagesCount;
}
