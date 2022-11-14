import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:spatial_flutter/basemap.dart';
import 'package:spatial_flutter/constants.dart';
import 'package:spatial_flutter/jts_2_fm_plotting_extensions.dart';

class MakePointPage extends StatelessWidget {
  static const String route = 'MakePointPage';

  const MakePointPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const kilifiLat = -3.634074;
    const kilifiLon = 39.866103;

    final kilifiPoint = geometryFactory.createPoint(
      Coordinate(kilifiLon, kilifiLat),
    );

    return BaseMap(
      center: kilifiPoint.toLatLng(),
      zoom: 15,
      onTap: print,
      markerLayerOptionsList: [
        MarkerLayerOptions(
          markers: [
            kilifiPoint.plot(
              builder: (context) => const Icon(
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
    );
  }
}
