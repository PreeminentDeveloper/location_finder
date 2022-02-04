import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_finder/model/location_model.dart';
import 'package:location_finder/.env.dart';
import 'package:http/http.dart';

class HTTPService {
  static const String _baseUrl = "https://enpuyr7bafpswlw.m.pipedream.net";
  // final Dio _dio;

  // HTTPService({Dio dio}) : _dio = dio ?? Dio();

  Future getLocation(
      //   {
      //   @required LatLng origin,
      //   @required LatLng destination,
      // }
      ) async {
    try {
      // final response = await _dio.get(_baseUrl, queryParameters: {
      //   'origin': '${origin.latitude},${origin.longitude},',
      //   'destination': '${destination.latitude},${destination.longitude},',
      //   'key': googleAPIKey,
      // });
      final response = await get(Uri.parse(_baseUrl));
      final json = jsonDecode(response.body);
      // print("Response: ${response.body}");

      // if (response.statusCode == 200) {
      //   return LocationModel.fromMap(response.data);
      // }
      return json;
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }
}



























// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:location_finder/model/location_model.dart';

// class HttpService {
//   static const String locationUrl = "https://enpuyr7bafpswlw.m.pipedream.net";
//   Map body;

//   Future<List<LocationModel>> getComics() async {
//     Response response = await get(locationUrl);
//     if (response.statusCode == 200) {
//       body = jsonDecode(response.body);
//       List data = body['data']['results'];
//       // print(data.toString());
//       List<LocationModel> locationData = [];

//       for (var location in data) {
//         LocationModel data = LocationModel(location["lat"], location["lng"],
//             location["name"], location["active"]);
//         locationData.add(data);
//       }

//       return locationData;
//     } else {
//       throw "Can't get data.";
//     }
//   }
// }
