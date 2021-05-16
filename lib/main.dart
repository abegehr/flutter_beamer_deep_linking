import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class BookRouteInformationParser extends RouteInformationParser<BookRoutePath> {
  @override
  Future<BookRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    print("BookRouteInformationParser – routeInformation: $routeInformation");

    final uri = Uri.parse(routeInformation.location!);
    // Handle '/'
    if (uri.pathSegments.length == 0) {
      return BookRoutePath.home();
    }

    // Handle '/book/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'book') return BookRoutePath.home();
      var remaining = uri.pathSegments[1];
      var id = int.tryParse(remaining);
      if (id == null) return BookRoutePath.home();
      return BookRoutePath.details(id);
    }

    // Handle unknown routes
    return BookRoutePath.home();
  }

  @override
  RouteInformation restoreRouteInformation(BookRoutePath path) {
    if (path.isBook) {
      return RouteInformation(location: '/book/${path.id}');
    }
    return RouteInformation(location: '/');
  }
}

class BookRouterDelegate extends RouterDelegate<BookRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BookRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  int? _id;

  BookRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  BookRoutePath get currentConfiguration {
    return _id == null ? BookRoutePath.home() : BookRoutePath.details(_id);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: ValueKey('BooksPage'),
          child: BooksScreen(onTap: _handleBookTapped),
        ),
        if (_id != null)
          MaterialPage(
            key: ValueKey('BooksPage'),
            child: BookDetailsScreen(_id!),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        _id = null;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(BookRoutePath path) async {
    if (path.isBook) {
      _id = path.id;
    } else {
      _id = null;
    }
  }

  void _handleBookTapped(int id) {
    _id = id;
    notifyListeners();
  }
}

class BookRoutePath {
  final int? id;

  BookRoutePath.home() : id = null;

  BookRoutePath.details(this.id);

  bool get isBook => id != null;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Beamer Deep Linking',
      routeInformationParser: BookRouteInformationParser(),
      routerDelegate: BookRouterDelegate(),
    );
  }
}

class BooksScreen extends StatelessWidget {
  final Function(int)? onTap;
  BooksScreen({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Beamer Deep Linking - Books"),
      ),
      body: ListView.builder(
        itemBuilder: (context, id) => ListTile(
          onTap: () {
            this.onTap!(id);
          },
          leading: Icon(CupertinoIcons.book),
          title: Text("Book $id"),
        ),
      ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  final int id;
  BookDetailsScreen(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Beamer Deep Linking – Book $id"),
      ),
      body: Center(child: Text("This is book #$id.")),
    );
  }
}
