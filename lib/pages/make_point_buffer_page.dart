import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' hide Polygon;
import 'package:spatial_flutter/basemap.dart';
import 'package:spatial_flutter/constants.dart';
import 'package:spatial_flutter/jts_2_fm_plotting_extensions.dart';

class MakePointBufferPage extends StatelessWidget {
  static const String route = 'MakePointBufferPage';

  const MakePointBufferPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const kilifiLat = -3.634074;
    const kilifiLon = 39.866103;

    final kilifiPoint = geometryFactory.createPoint(
      Coordinate(kilifiLon, kilifiLat),
    );

    final kilifiBuffer = kilifiPoint.buffer(0.002) as Polygon;

    return BaseMap(
      center: kilifiPoint.toLatLng(),
      bounds: kilifiBuffer.latLngBounds(),
      markerLayerOptionsList: [
        MarkerLayerOptions(
          markers: [
            kilifiPoint.plot(
              builder: (context) => const Icon(
                Icons.beach_access,
                size: 60,
              ),
              height: 60,
              width: 60,
            )
          ],
        )
      ],
      polygonLayerOptionsList: [
        PolygonLayerOptions(
          polygons: [
            kilifiBuffer.plot(
              borderColor: Colors.red,
              borderStrokeWidth: 1.5,
              color: Colors.green.withOpacity(0.1),
            ),
          ],
        )
      ],
    );
  }
}
