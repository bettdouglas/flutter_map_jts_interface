import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatial_flutter/pages/animated_linestring_page.dart';
import 'package:spatial_flutter/pages/linestring_buffer_page.dart';
import 'package:spatial_flutter/pages/make_linestring_page.dart';
import 'package:spatial_flutter/pages/make_point_buffer_page.dart';
import 'package:spatial_flutter/pages/make_point_page.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _currentIndex = 0;

  final pages = [
    MakePointPage(),
    MakePointBufferPage(),
    MakeLinestringPage(),
    MakeLinestringBufferPage(),
    LinestringAnimationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: BackdropScaffold(
        appBar: BackdropAppBar(
          title: Text('Dart JTS Examples'),
        ),
        stickyFrontLayer: true,
        backLayer: BackdropNavigationBackLayer(
          items: [
            ListTile(
              title: Text('Points'),
              subtitle: Text('Plot points in dart jts'),
            ),
            ListTile(
              title: Text('Buffer around points'),
              subtitle: Text('How to create a buffer around a point'),
            ),
            ListTile(
              title: Text('Linestring'),
              subtitle: Text('How to plot linestrings'),
            ),
            ListTile(
              title: Text('Linestring buffers'),
              subtitle: Text('Create a buffer along a linestring'),
            ),
          ],
          onTap: (idx) => setState(() => _currentIndex = idx),
        ),
        frontLayer: pages[_currentIndex],
      ),
    );
  }
}
