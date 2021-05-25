import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:spatial_flutter/basemap.dart';
import 'package:spatial_flutter/constants.dart';
import 'package:spatial_flutter/drawer.dart';
import 'package:spatial_flutter/pages/app_bar.dart';
import 'package:spatial_flutter/jts_2_fm_plotting_extensions.dart';
import 'package:latlong/latlong.dart';

class MakeLinestringPage extends StatelessWidget {
  static final String route = 'MakeLinestringPage';

  @override
  Widget build(BuildContext context) {
    final kilifiLat = -3.639;
    final kilifiLon = 39.864;

    final nyaliLat = -4.020;
    final nyaliLon = 39.7192;

    final mombasaCourtLat = -4.044;
    final mombasaCourtLon = 39.6575;

    final mombasaRatnaLat = -4.0465;
    final mombasaRatnaLon = 39.6847;

    final likoniLat = -4.0748;
    final likoniLon = 39.6660;

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

    return Scaffold(
      appBar: makeAppBar('Make Point'),
      drawer: buildDrawer(context, route),
      body: BaseMap(
        center: kilifiPoint.toLatLng(),
        bounds: bounds,
        fitBoundsOptions: FitBoundsOptions(padding: EdgeInsets.all(100)),
        zoom: 12,
        onMapTapped: null,
        markerLayerOptionsList: [
          MarkerLayerOptions(
            markers: pointGeometries
                .map(
                  (e) => e.plot(
                    builder: (context) => Icon(
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
            onTap: (TaggedPolyline polyline) => print(polyline.tag),
            onMiss: () => print('No polyline tapped'),
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
                strokeWidth: 10,
              )
            ],
          )
        ],
      ),
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
