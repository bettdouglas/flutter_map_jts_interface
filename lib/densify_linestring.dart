import 'dart:math';

import 'package:dart_jts/dart_jts.dart';
import 'package:spatial_flutter/constants.dart';

class Densifier {
  final Geometry geom;
  final double distanceTolerance;

  Densifier(this.geom, {this.distanceTolerance = 1.0}) {
    if (distanceTolerance <= 0.0) {
      throw ArgumentError(
        'Tolerance must be positive. distanceTolerance provided: $distanceTolerance',
      );
    }
  }

  /// Static method to densify a geometry by inserting vertices every maxLength
  /// distance along linear components

  Geometry densify() {
    if (geom.isEmpty() || geom.getDimension() == 0) {
      return geom;
    }
    final densifiedGeometries = List.generate(
      geom.getNumGeometries(),
      (index) => densifyGeometry(geom.getGeometryN(index)),
    );
    return geometryFactory.buildGeometry(densifiedGeometries);
  }

  Geometry densifyGeometry(Geometry geometry) {
    if (geometry.getDimension() == 1) {
      return densifyLineString(geometry as LineString);
    } else if (geometry.getDimension() == 2) {
      return densifyPolygon(geometry as Polygon);
    } else {
      return geometry;
    }
  }

  Polygon densifyPolygon(Polygon polygon) {
    final exteriorRing = densifyLinearRing(polygon.getExteriorRing());
    final holesLength = polygon.getNumInteriorRing();
    final holes = List.generate(
      holesLength,
      (index) => densifyLinearRing(
        polygon.getInteriorRingN(index),
      ),
    );
    return geometryFactory.createPolygon(exteriorRing, holes);
  }

  LineString densifyLineString(LineString ring) {
    final coordinateSequence = ring.getCoordinateSequence();
    final sequenceSize = coordinateSequence.size();
    final coordinateList = CoordinateList();
    for (var i = 0; i < sequenceSize; i++) {
      final densifiedCoordinateList = _densifySequence(coordinateSequence, i);
      coordinateList.addList(
        densifiedCoordinateList.toCoordinateArray(),
        false,
      );
    }
    coordinateList.add(
      coordinateSequence.getCoordinate(sequenceSize - 1),
    );
    return geometryFactory.createLineString(coordinateList.toCoordinateArray());
  }

  LinearRing densifyLinearRing(LinearRing ring) {
    final coordinateSequence = ring.getCoordinateSequence();
    final sequenceSize = coordinateSequence.size();
    final coordinateList = CoordinateList();
    for (var i = 0; i < sequenceSize; i++) {
      final densifiedCoordinateList = _densifySequence(coordinateSequence, i);
      coordinateList.addList(
        densifiedCoordinateList.toCoordinateArray(),
        false,
      );
    }
    coordinateList.add(
      coordinateSequence.getCoordinate(sequenceSize - 1),
    );
    return geometryFactory.createLinearRing(coordinateList.toCoordinateArray());
  }

  CoordinateList _densifySequence(
    CoordinateSequence seq,
    int index,
  ) {
    if (index == 0) return CoordinateList();

    Coordinate p0 = seq.getCoordinate(index - 1);
    Coordinate p1 = seq.getCoordinate(index);

    double dx = (p1.x - p0.x);
    double dy = (p1.y - p0.y);
    double dz = (p1.z - p0.z);
    double frac = sqrt((dx * dx) + (dy * dy)) / distanceTolerance;
    dx = dx / frac;
    dy = dy / frac;
    dz = dz / frac;

    /// * 0.9999 to avoid to add a point too close next to point
    final coordinateList = CoordinateList();
    int nbSegments = (frac + 0.9999).toInt();
    for (var i = 0; i < nbSegments; i++) {
      double x = p0.x + i * dx;
      double y = p0.y + i * dy;
      double z = p0.z + i * dz;
      final pt = Coordinate.fromXYZ(x, y, z);
      coordinateList.add(pt);
    }
    return coordinateList;
  }

  List<Coordinate> densifyPoints(
    List<Coordinate> pts,
    double distanceTolerance,
    PrecisionModel precisionModel,
  ) {
    LineSegment lineSegment = LineSegment.empty();
    CoordinateList coordinateList = CoordinateList();
    for (var i = 0; i < pts.length - 1; i++) {
      lineSegment.p0 = pts[i];
      lineSegment.p1 = pts[i + 1];
      coordinateList.addCoord(lineSegment.p0, false);
      double len = lineSegment.getLength();
      if (len <= distanceTolerance) {
        continue;
      }
      int densifiedSegmentCount = (len / distanceTolerance).ceil();
      final densifiedLineSegmentLength = len / densifiedSegmentCount;
      for (var j = 0; j < densifiedSegmentCount; j++) {
        double segFract = (j * densifiedLineSegmentLength) / len;
        Coordinate p = lineSegment.pointAlong(segFract);
        precisionModel.makeCoordinatePrecise(p);
        coordinateList.addCoord(p, false);
      }
    }
    // this check handles empty sequences
    if (pts.length > 0) {
      coordinateList.addCoord(pts[pts.length - 1], false);
    }
    return coordinateList.toCoordinateArray();
  }
}
