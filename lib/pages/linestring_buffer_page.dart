import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' hide Polygon;
import 'package:spatial_flutter/basemap.dart';
import 'package:spatial_flutter/constants.dart';
import 'package:spatial_flutter/jts_2_fm_plotting_extensions.dart';

class MakeLinestringBufferPage extends StatelessWidget {
  static const String route = 'MakeLinestringBufferPage';

  const MakeLinestringBufferPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const kilifiLat = -3.639;
    const kilifiLon = 39.864;

    const nyaliLat = -4.020;
    const nyaliLon = 39.7192;

    const mombasaCourtLat = -4.044;
    const mombasaCourtLon = 39.6575;

    const mombasaRatnaLat = -4.0465;
    const mombasaRatnaLon = 39.6847;

    const likoniLat = -4.0748;
    const likoniLon = 39.6660;

    final kilifiPoint = Coordinate(kilifiLon, kilifiLat);

    final nyaliPoint = Coordinate(nyaliLon, nyaliLat);
    final mombasaCourtPoint = Coordinate(mombasaCourtLon, mombasaCourtLat);
    final mombasaRatnaPoint = Coordinate(mombasaRatnaLon, mombasaRatnaLat);
    final likoniPoint = Coordinate(likoniLon, likoniLat);

    final coordinates = [
      kilifiPoint,
      nyaliPoint,
      mombasaRatnaPoint,
      mombasaCourtPoint,
      likoniPoint,
    ];

    final pointGeometries = coordinates.map(
      (e) => geometryFactory.createPoint(e),
    );

    final lineString = geometryFactory.createLineString(
      coordinates,
    );

    final lineStringBuffer = lineString.buffer(0.01) as Polygon;

    final bounds = lineStringBuffer.latLngBounds();

    return BaseMap(
      center: kilifiPoint.toLatLng(),
      bounds: bounds,
      fitBoundsOptions: const FitBoundsOptions(padding: EdgeInsets.all(100)),
      markerLayerOptionsList: [
        MarkerLayerOptions(
          markers: pointGeometries
              .map(
                (e) => e.plot(
                  builder: (context) => const Icon(
                    Icons.local_shipping,
                    color: Colors.black,
                  ),
                  height: 60,
                  width: 60,
                ),
              )
              .toList(),
        )
      ],
      polylineLayerOptionsList: [
        PolylineLayerOptions(
          polylines: [
            lineString.plot(
              borderColor: Colors.transparent,
              borderStrokeWidth: 1,
              strokeWidth: 4,
              color: Colors.red,
              isDotted: false,
            ),
          ],
        )
      ],
      polygonLayerOptionsList: [
        PolygonLayerOptions(
          polygons: [
            lineStringBuffer.plot(
              color: Colors.lightGreen,
              borderColor: Colors.black,
            )
          ],
        )
      ],
    );
  }
}
