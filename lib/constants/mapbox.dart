import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapboxConstants {
  static String accessToken =
      'pk.eyJ1IjoiYW5keS1iaW9uaWMiLCJhIjoiY21kZ2w5azNkMHI3MTJrczk4bm1hejltYSJ9.0Hn_MVX_8DM6KpghKhVETw';

  static final defaultCamera = CameraOptions(
    center: Point(coordinates: Position(6.450693, 9.534526)),
    zoom: 14.0,
    pitch: 0,
    bearing: 0,
  );
}
