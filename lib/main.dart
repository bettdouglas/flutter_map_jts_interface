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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MakePointPage(),
      routes: {
        MakePointPage.route: (_) => MakePointPage(),
        MakePointBufferPage.route: (_) => MakePointBufferPage(),
        MakeLinestringPage.route: (_) => MakeLinestringPage(),
        MakeLinestringBufferPage.route: (_) => MakeLinestringBufferPage(),
        LinestringAnimationPage.route: (_) => LinestringAnimationPage(),
      },
    );
  }
}
