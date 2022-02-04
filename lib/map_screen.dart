import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_finder/service/http_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double _lat, _lng;
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(6.45407, 3.39467), zoom: 12.0);

  GoogleMapController _googleMapController;
  Marker _origin;
  Marker _destination;
  bool loading = false;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("Location Finder"),
          actions: [
            TextButton(
              onPressed: () => _onButtonPressed(),
              style: TextButton.styleFrom(
                  primary: Colors.red,
                  textStyle: TextStyle(fontWeight: FontWeight.bold)),
              child: loading
                  ? SizedBox(
                      width: 15, height: 15, child: CircularProgressIndicator())
                  : Text("LOCATIONS"),
            ),
            if (_origin != null)
              TextButton(
                onPressed: () => _googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        target: _origin.position, zoom: 14.5, tilt: 50.0))),
                style: TextButton.styleFrom(
                    primary: Colors.green,
                    textStyle: TextStyle(fontWeight: FontWeight.bold)),
                child: Text("ORIGIN"),
              ),
            if (_destination != null)
              TextButton(
                onPressed: () => _googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        target: _destination.position,
                        zoom: 14.5,
                        tilt: 50.0))),
                style: TextButton.styleFrom(
                    primary: Colors.blue,
                    textStyle: TextStyle(fontWeight: FontWeight.bold)),
                child: Text("DEST"),
              )
          ],
        ),
        body: GoogleMap(
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: (controller) => _googleMapController = controller,
          markers: {
            if (_origin != null) _origin,
            if (_destination != null) _destination,
          },
          onTap: _addMarker,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.black,
          onPressed: () => _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition)),
          child: Icon(Icons.center_focus_strong),
        ));
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _origin = Marker(
          markerId: MarkerId('origin'),
          infoWindow: InfoWindow(title: "Origin"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );

        print("Position: $pos");
        _destination = null;
      });
    } else {
      setState(() {
        _destination = Marker(
          markerId: MarkerId('destination'),
          infoWindow: InfoWindow(title: "Destination"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });
    }
  }

  void _onButtonPressed() async {
    setState(() => loading = true);
    final locationModel = await HTTPService().getLocation();
    print("Location Model: $locationModel");
    setState(() => loading = false);

    // setState(() => _data = locationModel);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Available locations",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 5),
                      Icon(Icons.location_on, size: 12),
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                        itemCount: locationModel.length,
                        itemBuilder: (context, index) {
                          final locations = locationModel[index];
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () => _selectLocation(
                                      double.parse(locations["lat"]),
                                      double.parse(locations["lng"])),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.circle,
                                              size: 10,
                                              color: locations["active"] == true
                                                  ? Colors.green
                                                  : Colors.red),
                                          SizedBox(width: 20),
                                          Text(locations["name"]),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _selectLocation(double lat, double lng) {
    Navigator.pop(context);
    setState(() {
      _lat = lat;
      _lng = lng;
      print("Lat: $_lat, Lng: $_lng");
    });
    _gotoLocation(_lat, _lng);
    LatLng selectedLocation = LatLng(_lat, _lng);
    _addMarker(selectedLocation);
  }

  Future<void> _gotoLocation(double lat, double long) async {
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 14.5,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }
}
