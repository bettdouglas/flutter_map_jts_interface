import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatial_flutter/basemap.dart';
import 'package:spatial_flutter/constants.dart';
import 'package:spatial_flutter/densify_linestring.dart';
import 'package:spatial_flutter/jts_2_fm_plotting_extensions.dart';

import '../timer_stream.dart';

class LinestringAnimationPage extends ConsumerWidget {
  static const String route = 'LinestringAnimationPage';

  const LinestringAnimationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final bounds = lineString.latLngBounds();

    final densified = Densifier(
      lineString,
      distanceTolerance: 0.03,
    ).densify() as LineString;

    print(densified.getCoordinates().length);

    // print(mombasaRatnaPoint.distance(likoniPoint));

    final currentIdx = ref.watch(timerListener).maybeWhen(
          orElse: () => 1,
          data: (data) => data,
        );

    // print(currentIdx);

    return BaseMap(
      center: kilifiPoint.toLatLng(),
      bounds: bounds,
      fitBoundsOptions: const FitBoundsOptions(padding: EdgeInsets.all(100)),
      zoom: 12,
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
        ),
        MarkerLayerOptions(
          markers: densified
              .getCoordinates()
              .map(geometryFactory.createPoint)
              .toList()
              .asMap()
              .map(
                (idx, e) => MapEntry(
                  idx,
                  e.plot(
                    builder: (context) => Icon(
                      Icons.sanitizer_rounded,
                      color: idx == currentIdx ? Colors.red : Colors.green,
                    ),
                    height: 60,
                    width: 60,
                  ),
                ),
              )
              .values
              .toList(),
        )
      ],
      polylineLayerOptionsList: [
        PolylineLayerOptions(
          polylines: [
            lineString.plot(
              borderColor: Colors.transparent,
              borderStrokeWidth: 1,
              strokeWidth: 2,
              color: Colors.black,
              isDotted: false,
            ),
            densified.plot(
              borderColor: Colors.transparent,
              borderStrokeWidth: 1,
              strokeWidth: 2,
              color: Colors.red,
              isDotted: true,
            ),
          ],
        )
      ],
    );
  }
}
