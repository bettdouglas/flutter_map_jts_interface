import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:spatial_flutter/basemap.dart';
import 'package:spatial_flutter/constants.dart';
import 'package:spatial_flutter/drawer.dart';
import 'package:spatial_flutter/pages/app_bar.dart';
import 'package:spatial_flutter/jts_2_fm_plotting_extensions.dart';

class MakePointPage extends StatelessWidget {
  static final String route = 'MakePointPage';

  @override
  Widget build(BuildContext context) {
    final kilifiLat = -3.634074;
    final kilifiLon = 39.866103;

    final kilifiPoint = geometryFactory.createPoint(
      Coordinate(kilifiLon, kilifiLat),
    );

    return Scaffold(
      appBar: makeAppBar('Make Point'),
      drawer: buildDrawer(context, route),
      body: BaseMap(
        center: kilifiPoint.toLatLng(),
        zoom: 15,
        onMapTapped: print,
        markerLayerOptionsList: [
          MarkerLayerOptions(
            markers: [
              kilifiPoint.plot(
                builder: (context) => Icon(
                  Icons.beach_access,
                  color: Colors.green,
                  size: 100,
                ),
                height: 50,
                width: 50,
              )
            ],
          )
        ],
      ),
    );
  }
}
