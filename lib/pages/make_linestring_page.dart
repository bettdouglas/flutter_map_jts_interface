import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:spatial_flutter/basemap.dart';
import 'package:spatial_flutter/constants.dart';
import 'package:spatial_flutter/jts_2_fm_plotting_extensions.dart';
import 'package:latlong2/latlong.dart';

class MakeLinestringPage extends StatelessWidget {
  static const String route = 'MakeLinestringPage';

  const MakeLinestringPage({Key? key}) : super(key: key);

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

    final bounds = lineString.latLngBounds();

    return BaseMap(
      center: kilifiPoint.toLatLng(),
      bounds: bounds,
      fitBoundsOptions: const FitBoundsOptions(padding: EdgeInsets.all(100)),
      zoom: 12,
      onTap: null,
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
      polylineLayerOptionsList: const [
        // PolylineLayerOptions(
        //   polylines: [
        //     lineString.plot(
        //       borderColor: Colors.transparent,
        //       borderStrokeWidth: 1,
        //       strokeWidth: 2,
        //       color: Colors.black,
        //       isDotted: false,
        //     ),
        //   ],
        // )
      ],
      tappablePolylineList: [
        TappablePolylineLayerOptions(
          onTap: (taggedPolylines, tapUpDetails) => print(
            taggedPolylines.first,
          ),
          onMiss: (tapUpDetails) => print('No polyline tapped'),
          pointerDistanceTolerance: 20,
          polylineCulling: true,
          polylines: [
            TaggedPolyline(
              points: lineString
                  .plot(
                    borderColor: Colors.transparent,
                    borderStrokeWidth: 1,
                    strokeWidth: 2,
                    color: Colors.black,
                    isDotted: false,
                  )
                  .points,
              tag: 'Kilifi Road',
            ),
            TaggedPolyline(
              tag: 'Village Road',
              points: line2Coordinates,
              color: Colors.black,
              strokeWidth: 10.5,
            )
          ],
        )
      ],
    );
  }
}

final line2Coordinates = [
  LatLng(-3.727569, 39.824442),
  LatLng(-3.707468, 39.631453),
  LatLng(-3.794354, 39.718526),
  LatLng(-3.885121, 39.532035),
  LatLng(-3.798244, 39.459258),
];
