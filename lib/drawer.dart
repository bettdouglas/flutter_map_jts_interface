import 'package:flutter/material.dart';
import 'package:spatial_flutter/pages/animated_linestring_page.dart';
import 'package:spatial_flutter/pages/linestring_buffer_page.dart';
import 'package:spatial_flutter/pages/make_linestring_page.dart';
import 'package:spatial_flutter/pages/make_point_buffer_page.dart';
import 'package:spatial_flutter/pages/make_point_page.dart';

Widget _buildMenuItem(
  BuildContext context,
  Widget title,
  String routeName,
  String currentRoute,
) {
  var isSelected = routeName == currentRoute;

  return ListTile(
    title: title,
    selected: isSelected,
    onTap: () {
      if (isSelected) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, routeName);
      }
    },
  );
}

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          child: Center(
            child: Text('Spatial Examples JTS'),
          ),
        ),
        _buildMenuItem(
          context,
          Text('Point'),
          MakePointPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          Text('Point Buffer'),
          MakePointBufferPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          Text('LInestring'),
          MakeLinestringPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          Text('Linestring Buffer'),
          MakeLinestringBufferPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          Text('Linestring Animation'),
          LinestringAnimationPage.route,
          currentRoute,
        )
      ],
    ),
  );
}
