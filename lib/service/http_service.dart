import 'dart:convert';
import 'package:http/http.dart';

class HTTPService {
  static const String _baseUrl = "https://enpuyr7bafpswlw.m.pipedream.net";
  Future getLocation() async {
    try {
      final response = await get(Uri.parse(_baseUrl));
      final json = jsonDecode(response.body);
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
