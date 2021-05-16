import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Beamer Deep Linking',
      routeInformationParser: BeamerRouteInformationParser(),
      routerDelegate: BeamerRouterDelegate(
        locationBuilder: SimpleLocationBuilder(
          routes: {
            '/': (context) => HomeScreen(),
            '/books': (context) => BooksScreen(),
            '/books/:id': (context) => BookDetailsScreen()
          },
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Beamer Deep Linking"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Beamer.of(context).beamToNamed('/books');
          },
          child: Text("Go to books"),
        ),
      ),
    );
  }
}

class BooksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Beamer Deep Linking - Books"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            Beamer.of(context).beamToNamed('/books/$index');
          },
          leading: Icon(CupertinoIcons.book),
          title: Text("Book $index"),
        ),
      ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final id = Beamer.of(context).currentLocation.state.pathParameters['id'];
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Beamer Deep Linking – Book $id"),
      ),
      body: Center(child: Text("This is book #$id.")),
    );
  }
}
