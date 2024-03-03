import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_page.dart';
import 'pages/default_home_page.dart';
import 'pages/page_404_page.dart';

const String _k404Name = '/404';

class PageManager extends ChangeNotifier {
  PageManager([this.routeInformation]);
  PageManager.fromRouteInformation(
    this.routeInformation,
    PageManager currentPageManager,
  ) {
    setHomePage(currentPageManager._onBoardingPage);
    set404Page(currentPageManager._page404Widget);
    _pages.clear();
    _pages.addAll(currentPageManager._getAllPages);
    if (routeInformation != null) {
      final Uri uri = routeInformation?.uri ?? Uri();
      final CustomPage page =
          currentPageManager._getPageFromDirectory(uri.path);
      currentPageManager.push(_onBoardingPage);
      currentPageManager.pushFromRoutesettings(uri.path, page);
    }
  }
  CustomPage _page404Widget = page404Page;
  CustomPage _onBoardingPage = defaultHomePage;

  void update() {
    print('Actualizando');
    notifyListeners();
  }

  void removePageFromRoute(String route) {
    _removePageFromRoute(route);
    notifyListeners();
  }

  void _removePageFromRoute(String route) {
    if (route == '/') {
      return;
    }
    _directoryPagesMap.remove(route);
    final List<CustomPage> tmpPages = <CustomPage>[];
    for (final CustomPage tmp in _pages) {
      if (tmp.name != route) {
        tmpPages.add(tmp);
      }
    }
    _pages.clear();
    _pages.addAll(tmpPages);
  }

  String setPageTitle(String title, [int? color]) {
    title = title.replaceAll('/', ' ').trim();
    if (kIsWeb) {
      try {
        SystemChrome.setApplicationSwitcherDescription(
          ApplicationSwitcherDescription(
            label: title,
            primaryColor: color, // This line is required
          ),
        );
      } catch (e) {
        debugPrint('$e');
      }
    }
    return title;
  }

  final Map<String, CustomPage> _directoryPagesMap = <String, CustomPage>{};

  List<String> get directoryOfPages => _directoryPagesMap.keys.toList();

  void registerPageToDirectory({
    required CustomPage customPage,
  }) {
    final String routeName = validateRouteName(customPage.routeName);
    _directoryPagesMap[routeName] = customPage;
  }

  void removePageFromDirectory(String routeName) {
    _directoryPagesMap.remove(routeName);
    notifyListeners();
  }

  void _cleanDuplicateHomePages() {
    if (_pages.length > 1) {
      final List<CustomPage> tmpPages = <CustomPage>[
        _pages[0],
      ];
      for (int i = 1; i < _pages.length; i++) {
        final CustomPage value = _pages[i];
        if (value.name != '/') {
          tmpPages.add(value);
        }
      }
      _pages.clear();
      _pages.addAll(tmpPages);
    }
  }

  void setHomePage(CustomPage customPage) {
    /// This acts like the base of the navigator the main idea is first set the starting functions,
    _directoryPagesMap['/'] = customPage;
    _pages[0] = _directoryPagesMap['/']!;
    _cleanDuplicateHomePages();
    _onBoardingPage = customPage;
  }

  void set404Page(CustomPage customPage) {
    _directoryPagesMap[_k404Name] = customPage;
    _page404Widget = customPage;
  }

  final List<CustomPage> _pages = <CustomPage>[
    defaultHomePage,
  ];
  List<CustomPage> get history => _pages;

  PageManager get currentConfiguration => this;

  bool isThisRouteNameInDirectory(String routeName) {
    return _directoryPagesMap.containsKey(validateRouteName(routeName));
  }

  String validateRouteName(String routeName) {
    if (routeName.isEmpty || routeName[0] != '/') {
      routeName = '/$routeName';
    }
    return routeName;
  }

  void push(CustomPage customPage) {
    final String routeName = validateRouteName(customPage.routeName);

    _directoryPagesMap[routeName] = customPage;
    _pages.remove(customPage);
    _pages.add(customPage);

    notifyListeners();
  }

  void pushAndReplacement(
    CustomPage customPage,
  ) {
    back();
    push(customPage);
  }

  void pushNamed(String routeName) {
    final CustomPage customPage = _getPageFromDirectory(routeName);
    push(customPage);
  }

  void pushNamedAndReplacement(String routeName) {
    back();
    final CustomPage customPage = _getPageFromDirectory(routeName);
    push(customPage);
  }

  void pushFromRoutesettings(
    String routeName,
    CustomPage routeSettings,
  ) {
    if (validateRouteName(routeName).length > 1) {
      _pages.remove(routeSettings);
      _pages.add(routeSettings);

      notifyListeners();
    }
  }

  int get historyPagesCount => _pages.length;

  RouteSettings get _currentPage => _pages.last;

  List<CustomPage> get pages =>
      <CustomPage>[List<CustomPage>.unmodifiable(_pages).last];
  final RouteInformation? routeInformation;

  List<CustomPage> get _getAllPages => List<CustomPage>.unmodifiable(_pages);

  void back() {
    if (_pages.length > 1) {
      _pages.removeLast();
      notifyListeners();
    }
  }

  bool didPop(Route<dynamic> route, dynamic result) {
    back();
    return true;
  }

  CustomPage _getPageFromDirectory(String routeName) {
    return _directoryPagesMap[routeName] ?? _get404PageFromDirectory();
  }

  CustomPage _get404PageFromDirectory() {
    return _directoryPagesMap[_k404Name] ?? _page404Widget;
  }

  RouteInformation? getCurrentUrl() {
    final Uri uri = Uri(
      path: _currentPage.name,
      queryParameters: _currentPage.arguments as Map<String, dynamic>?,
    );
    String location = uri.path;
    if (uri.query.isNotEmpty) {
      location = '$location?${uri.query}';
    }
    return RouteInformation(
      uri: Uri.tryParse(location),
    );
  }

  void clearHistory() {
    final CustomPage tmp = _pages[0];
    _pages.clear();
    _pages.add(tmp);
    notifyListeners();
  }

  @override
  void dispose() {
    _pages.clear();
    _directoryPagesMap.clear();
    super.dispose();
  }
}
