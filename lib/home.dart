import 'package:flutter/material.dart';
import 'package:running/draw_map.dart';
import 'package:wemapgl/wemapgl.dart';
import 'package:location/location.dart' as locationLib;
import 'package:flutter/services.dart';
import 'dart:typed_data';

class MapScreen extends StatefulWidget {
  static final String mapScreen = "/home";
  const MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  WeMapController mapController;
  final String _defaultAvatarUrl = "assets/default_avatar.png";
  locationLib.Location location;
  int _tripDistance = 0;
  WeMapDirections directionAPI = WeMapDirections();
  DrawMap _drawMap = new DrawMap();
  locationLib.LocationData currentLocation;
  List<LatLng> points = [];
  bool isStart = false;
  void _onMapCreated(WeMapController controller) {
    mapController = controller;
  }

  int count = 0;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  @override
  void initState() {
    location = new locationLib.Location();
    location.changeSettings(interval: 10000, distanceFilter: 20);
    location.onLocationChanged
        .listen((locationLib.LocationData currentLoc) async {
      if (isStart) {
        currentLocation = currentLoc;
        final json = await directionAPI.getResponseMultiRoute(
            2, points); //0 = car, 1 = bike, 2 = foot
        setState(() {
          _tripDistance = directionAPI.getDistance(json);
        });
        points.add(
            new LatLng(currentLocation.latitude, currentLocation.longitude));
        await mapController.clearLines();
        await mapController.clearSymbols();
        await mapController.addLine(
          LineOptions(
            geometry: [...points],
            lineColor: "#0071bc",
            lineWidth: 10.0,
            lineOpacity: 0.5,
          ),
        );
        await _onStyleLoaded(currentLoc.latitude, currentLoc.longitude);
        mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: new LatLng(currentLoc.latitude, currentLoc.longitude),
              zoom: 16.0,
            ),
          ),
        );
        print("xxxxxx $_tripDistance ");
      } else {
        setState(() {
          _tripDistance = 0;
        });
        await mapController.clearLines();
        await mapController.clearSymbols();
        await _onStyleLoaded(currentLoc.latitude, currentLoc.longitude);
        mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: new LatLng(currentLoc.latitude, currentLoc.longitude),
              zoom: 16.0,
            ),
          ),
        );
      }
    });
    super.initState();
  }

  Future<void> _onStyleLoaded(double lat, double long) async {
    print("xxxxxxx 12331231231232 iamge $lat $long");
    final Uint8List list =
        await _drawMap.getBytesFromAsset(_defaultAvatarUrl, 100, 100);
    await mapController.addImage("123132", list);
    await mapController.addSymbol(
      SymbolOptions(
        geometry: LatLng(lat, long),
        iconImage: "123132",
        iconOpacity: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isStart == true) {
      startTime = DateTime.now();
    } else {
      endTime = DateTime.now();
    }
    print(endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: isStart ? Icon(Icons.pause) : Icon(Icons.not_started_outlined),
        onPressed: () {
          setState(() {
            isStart = !isStart;
            count += 1;
          });
        },
      ),
      body: Stack(
        children: [
          WeMap(
            onMapClick: (point, latlng, _place) async {
              // place = await _place;
            },
            onPlaceCardClose: () {
              // print("Place Card closed");
            },
            onStyleLoadedCallback: () async {
              locationLib.LocationData myLocation;
              locationLib.Location location = new locationLib.Location();
              myLocation = await location.getLocation();
              mapController.moveCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target:
                        new LatLng(myLocation.latitude, myLocation.longitude),
                    zoom: 16.0,
                  ),
                ),
              );
              await _onStyleLoaded(myLocation.latitude, myLocation.longitude);
            },
            reverse: true,
            onMapCreated: _onMapCreated,
            // myLocationEnabled: true,
            // myLocationRenderMode: MyLocationRenderMode.NORMAL,
            // compassEnabled: true,

            initialCameraPosition: const CameraPosition(
              target: LatLng(21.036029, 105.782950),
              zoom: 16.0,
            ),
            // destinationIcon: "assets/symbols/destination.png",
          ),
          (!isStart && count > 0)
              ? Positioned(
                  bottom: 20,
                  right: 30,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        child: Text(
                          "Xem kết quả",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      )),
                )
              : Container()
        ],
      ),
    );
  }
}

// void UserLocation() {}
