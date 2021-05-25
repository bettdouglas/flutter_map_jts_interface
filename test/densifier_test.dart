// void main() {

//    const TOLERANCE = 1e-6;

//   void testLine() {
//     checkDensify("LINESTRING (0 0, 30 40, 35 35)",
//         10, "LINESTRING (0 0, 6 8, 12 16, 18 24, 24 32, 30 40, 35 35)");
//   }

//   void testLineOfToleranceLength() {
//     checkDensify("LINESTRING (0 0, 10 0)",
//         10, "LINESTRING (0 0, 10 0)");
//   }

//   void testLineWithToleranceLengthSeg() {
//     checkDensify("LINESTRING (0 0, 12 0, 22 0, 34 0)",
//         10, "LINESTRING (0 0, 6 0, 12 0, 22 0, 28 0, 34 0)");
//   }

//   void testLineEmpty() {
//     checkDensify("LINESTRING EMPTY",
//         10, "LINESTRING EMPTY");
//   }

//   void testPointUnchanged() {
//     checkDensify("POINT (0 0)",
//         10, "POINT (0 0)");
//   }

//   void testPolygonEmpty() {
//     checkDensify("POLYGON EMPTY",
//         10, "POLYGON EMPTY");
//   }

//   void testBox() {
//     checkDensify("POLYGON ((10 30, 30 30, 30 10, 10 10, 10 30))",
//         10, "POLYGON ((10 10, 10 20, 10 30, 20 30, 30 30, 30 20, 30 10, 20 10, 10 10))");
//   }

//   void testBoxNoValidate() {
//     checkDensifyNoValidate("POLYGON ((10 30, 30 30, 30 10, 10 10, 10 30))",
//         10, "POLYGON ((10 10, 10 20, 10 30, 20 30, 30 30, 30 20, 30 10, 20 10, 10 10))");
//   }

//   void testDimension2d() {
//       GeometryFactory gf = new GeometryFactory();
//       LineString line = gf
//               .createLineString(new Coordinate[] { new CoordinateXY(1, 2), new CoordinateXY(3, 4) });
//       assertEquals(2, line.getCoordinateSequence().getDimension());

//       line = (LineString) Densifier.densify(line, 0.1);
//       assertEquals(2, line.getCoordinateSequence().getDimension());
//   }

//   void testDimension3d() {
//       GeometryFactory gf = new GeometryFactory();
//       LineString line = gf
//               .createLineString(new Coordinate[] { new Coordinate(1, 2, 3), new Coordinate(3, 4, 5) });
//       assertEquals(3, line.getCoordinateSequence().getDimension());

//       line = (LineString) Densifier.densify(line, 0.1);
//       assertEquals(3, line.getCoordinateSequence().getDimension());
//   }

//   /**
//    * Note: it's hard to construct a geometry which would actually be invalid when densified.
//    * This test just checks that the code path executes.
//    *
//    * @param wkt
//    * @param distanceTolerance
//    * @param wktExpected
//    */
//   void checkDensifyNoValidate(String wkt, double distanceTolerance, String wktExpected) {
//     Geometry geom = read(wkt);
//     Geometry expected = read(wktExpected);
//     Densifier den =  Densifier(geom);
//     den.setDistanceTolerance(distanceTolerance);
//     den.setValidate(false);
//     Geometry actual = den.getResultGeometry();
//     checkEqual(expected, actual, TOLERANCE);
//   }

// }

// }
