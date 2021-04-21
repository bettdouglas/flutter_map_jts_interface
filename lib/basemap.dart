import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

enum BaseTile { OSM, MB_DARK, MB_LIGHT, STAMEN }

class BaseMap extends StatelessWidget {
  final LatLng center;
  final double zoom;
  final List<MarkerLayerOptions> markerLayerOptionsList;
  final List<PolygonLayerOptions> polygonLayerOptionsList;
  final List<PolylineLayerOptions> polylineLayerOptionsList;
  final LatLngBounds bounds;
  final FitBoundsOptions fitBoundsOptions;
  final MapController mapController;
  final Function(LatLng) onMapTapped;

  const BaseMap({
    Key key,
    @required this.center,
    this.markerLayerOptionsList,
    this.polygonLayerOptionsList,
    this.polylineLayerOptionsList,
    this.zoom = 5.0,
    this.bounds,
    this.fitBoundsOptions,
    this.mapController,
    this.onMapTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layers = <LayerOptions>[
      TileLayerOptions(
        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c'],
      ),
    ];

    if (polygonLayerOptionsList != null) {
      layers.addAll(polygonLayerOptionsList);
    }

    if (polylineLayerOptionsList != null) {
      layers.addAll(polylineLayerOptionsList);
    }

    if (markerLayerOptionsList != null) {
      layers.addAll(markerLayerOptionsList);
    }

    return Container(
      child: FlutterMap(
        options: MapOptions(
          center: center,
          controller: mapController,
          zoom: zoom,
          bounds: bounds,
          boundsOptions:
              fitBoundsOptions ?? FitBoundsOptions(padding: EdgeInsets.all(20)),
          onTap: (point) {
            print(point);
          },
        ),
        layers: layers,
      ),
    );
  }
}
