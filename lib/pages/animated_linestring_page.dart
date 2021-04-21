import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:spatial_flutter/basemap.dart';
import 'package:spatial_flutter/constants.dart';
import 'package:spatial_flutter/densify_transformer.dart';
import 'package:spatial_flutter/drawer.dart';
import 'package:spatial_flutter/pages/app_bar.dart';
import 'package:spatial_flutter/jts_2_fm_plotting_extensions.dart';

class LinestringAnimationPage extends StatefulWidget {
  static final String route = 'LinestringAnimationPage';

  @override
  _LinestringAnimationPageState createState() =>
      _LinestringAnimationPageState();
}

class _LinestringAnimationPageState extends State<LinestringAnimationPage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    super.initState();
  }

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

    final densified = Densifier(
      lineString,
      distanceTolerance: 0.03,
    ).getResultGeometry() as LineString;

    print(mombasaRatnaPoint.distance(likoniPoint));

    return Scaffold(
      appBar: makeAppBar('Make Point'),
      drawer: buildDrawer(context, LinestringAnimationPage.route),
      body: BaseMap(
        center: kilifiPoint.toLatLng(),
        bounds: bounds,
        fitBoundsOptions: FitBoundsOptions(padding: EdgeInsets.all(100)),
        zoom: 12,
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
          ),
          MarkerLayerOptions(
            markers: densified
                .getCoordinates()
                .map(geometryFactory.createPoint)
                .map(
                  (e) => e.plot(
                    builder: (context) => Icon(
                      Icons.sanitizer_rounded,
                      color: Colors.green,
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
      ),
    );
  }
}
