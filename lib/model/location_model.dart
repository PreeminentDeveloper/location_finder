import 'package:flutter/foundation.dart';

class LocationModel {
  final double lat;
  final double lng;
  final String name;
  final bool active;

  LocationModel(@required this.lat, @required this.lng, @required this.name,
      @required this.active);

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    // final data = Map<String, dynamic>.from(map[0]);
    // this.lat = data['lat'];
    // this.lng = data['lng'];
    // this.name = data['name'];p
    // this.active = data['active'];
  }

  // return LocationModel(
  //   lat: lat,
  // );
}
