import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:latlong2/latlong.dart';

class BaseMap extends StatelessWidget {
  final LatLng center;
  final double zoom;
  final List<MarkerLayerOptions>? markerLayerOptionsList;
  final List<PolygonLayerOptions>? polygonLayerOptionsList;
  final List<PolylineLayerOptions>? polylineLayerOptionsList;
  final LatLngBounds? bounds;
  final FitBoundsOptions? fitBoundsOptions;
  final MapController? mapController;
  final Function(LatLng)? onTap;
  final List<TappablePolylineLayerOptions>? tappablePolylineList;

  const BaseMap({
    Key? key,
    required this.center,
    this.markerLayerOptionsList,
    this.polygonLayerOptionsList,
    this.polylineLayerOptionsList,
    this.zoom = 5.0,
    this.bounds,
    this.fitBoundsOptions,
    this.mapController,
    this.onTap,
    this.tappablePolylineList,
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
      layers.addAll(polygonLayerOptionsList!);
    }

    if (polylineLayerOptionsList != null) {
      layers.addAll(polylineLayerOptionsList!);
    }

    if (markerLayerOptionsList != null) {
      layers.addAll(markerLayerOptionsList!);
    }

    if (tappablePolylineList != null) {
      layers.addAll(tappablePolylineList!);
    }

    return FlutterMap(
      options: MapOptions(
        center: center,
        controller: mapController,
        zoom: zoom,
        bounds: bounds,
        boundsOptions: fitBoundsOptions ??
            const FitBoundsOptions(padding: EdgeInsets.all(20)),
        plugins: [
          TappablePolylineMapPlugin(),
        ],
        onTap: (tapPosition, point) {
          print(point);
        },
      ),
      layers: layers,
    );
  }
}
