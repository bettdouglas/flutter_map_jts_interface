import 'package:dart_jts/dart_jts.dart';

class GeometryTransformer {
  // final Geometry inputGeom;
  GeometryFactory geometryFactory;

  /// could probably be exposed to clients
  /// specifies if empty geometries should not be included in the result
  /// Default value is [true]
  var pruneEmptyGeometry = true;

  /// if a homogenous collection result from GeometryCollection should still be
  /// a general geometry.
  /// Default value is [true]
  var preserveGeometryCollectionType = true;

  /// [true] if the output from a collection argument should still be a collection
  /// defaults is [false]
  var preserveCollections = false;

  /// [true] if type of the input should be preserved
  var preserveType = false;

  GeometryTransformer();

  Geometry transform(Geometry inputG) {
    this.geometryFactory = inputG.geomFactory;
    if (inputG is Point) {
      return transformPoint(inputG, null);
    } else if (inputG is MultiPoint) {
      return transformMultiPoint(inputG, null);
    } else if (inputG is LinearRing) {
      return transformLinearRing(inputG, null);
    } else if (inputG is LineString) {
      return transformLineString(inputG, null);
    } else if (inputG is MultiLineString) {
      return transformMultiLineString(inputG, null);
    } else if (inputG is Polygon) {
      return transformPolygon(inputG, null);
    } else if (inputG is MultiPolygon) {
      return transformMultiPolygon(inputG, null);
    } else if (inputG is GeometryCollection) {
      return transformGeometryCollection(inputG, null);
    } else {
      throw ArgumentError(
        ("Unknown Geometry subtype: " + inputG.runtimeType.toString()),
      );
    }
  }

  CoordinateSequence transformCoordinates(
    CoordinateSequence coords,
    Geometry parent,
  ) {
    return coords.copy();
  }

  Point transformPoint(Point geom, Geometry parent) {
    return geometryFactory.createPointSeq(
      transformCoordinates(
        geom.getCoordinateSequence(),
        geom,
      ),
    );
  }

  Geometry transformMultiPoint(MultiPoint geom, Geometry parent) {
    final transGeomList = <Point>[];
    for (var i = 0; i < geom.getNumGeometries(); i++) {
      final transformedPoint = transformPoint(geom.getGeometryN(i), geom);
      if (transformedPoint == null) continue;
      if (transformedPoint.isEmpty()) continue;
      transGeomList.add(transformedPoint);
    }
    if (transGeomList.isEmpty) {
      return geometryFactory.createPointEmpty();
    } else {
      return geometryFactory.buildGeometry(transGeomList);
    }
  }

  ///Transforms a [LinearRing]
  ///The transformation of a [geom] may result in a coordinate sequence which
  ///does not form a structurally valid ring(i.e a degenerate ring of 3 or fewer points).
  ///In this case a LineString is returned
  ///Subclasses may wish to override this method and check for this situation
  ///(e.g a subclass may choose to eliminate degenrate linear rings)
  ///
  Geometry transformLinearRing(LinearRing geom, Geometry parent) {
    final seq = transformCoordinates(geom.getCoordinateSequence(), geom);
    if (seq == null) {
      return geometryFactory.createLinearRingEmpty();
    }
    int seqSize = seq.size();
    if (seqSize > 0 && seqSize < 4 && !preserveType) {
      return geometryFactory.createLineStringSeq(seq);
    }
    return geometryFactory.createLinearRingSeq(seq);
  }

  ///Transforms a [LineString geometry]
  Geometry transformLineString(LineString geom, Geometry parent) {
    return geometryFactory.createLineStringSeq(
      transformCoordinates(
        geom.getCoordinateSequence(),
        geom,
      ),
    );
  }

  Geometry transformMultiLineString(MultiLineString geom, Geometry parent) {
    final transGeomList = <Geometry>[];
    for (var i = 0; i < geom.getNumGeometries(); i++) {
      final transformGeom = transformLineString(geom.getGeometryN(i), geom);
      if (transformGeom == null) continue;
      if (transformGeom.isEmpty()) continue;
      transGeomList.add(transformGeom);
    }
    if (transGeomList.isEmpty) {
      return geometryFactory.createMultiLineStringEmpty();
    }
    return geometryFactory.buildGeometry(transGeomList);
  }

  Geometry transformPolygon(Polygon geom, Geometry parent) {
    var isAllValidLinearRings = true;
    final shell = transformLinearRing(geom.getExteriorRing(), geom);
    final shellIsNullOrEmpty = shell == null || shell.isEmpty();
    if (geom.isEmpty() && shellIsNullOrEmpty) {
      return geometryFactory.createPolygonEmpty();
    }
    if (shellIsNullOrEmpty || !(shell is LinearRing)) {
      isAllValidLinearRings = false;
    }
    final holes = <Geometry>[];
    for (var i = 0; i < geom.getNumInteriorRing(); i++) {
      final hole = transformLinearRing(geom.getInteriorRingN(i), geom);
      if (hole == null || hole.isEmpty()) {
        continue;
      }
      if (!(hole is LinearRing)) {
        isAllValidLinearRings = false;
      }
      holes.add(hole);
    }
    if (isAllValidLinearRings) {
      return geometryFactory.createPolygon(shell, holes);
    } else {
      final components = [];
      if (shell != null) {
        components.add(shell);
      }
      components.addAll(holes);
      return geometryFactory.buildGeometry(components);
    }
  }

  Geometry transformMultiPolygon(MultiPolygon geom, Geometry parent) {
    final transGeomList = <Geometry>[];
    for (var i = 0; i < geom.getNumGeometries(); i++) {
      Geometry transformGeom = transformPolygon(geom.getGeometryN(i), geom);
      if (transformGeom == null) continue;
      if (transformGeom.isEmpty()) continue;
      transGeomList.add(transformGeom);
    }

    if (transGeomList.isEmpty) {
      return geometryFactory.createMultiPolygonEmpty();
    }
    return geometryFactory.buildGeometry(transGeomList);
  }

  Geometry transformGeometryCollection(
    GeometryCollection geom,
    Geometry parent,
  ) {
    final transGeomList = <Geometry>[];
    for (var i = 0; i < geom.getNumGeometries(); i++) {
      Geometry transformGeom = transform(
        geom.getGeometryN(i),
      );
      if (transformGeom == null) continue;
      if (transformGeom.isEmpty()) continue;
      transGeomList.add(transformGeom);
    }

    if (preserveGeometryCollectionType) {
      return geometryFactory.createGeometryCollection(transGeomList);
    } else {
      return geometryFactory.buildGeometry(transGeomList);
    }
  }
}
