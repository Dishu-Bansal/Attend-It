import 'dart:ui';

import 'package:attend_it/screens/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

bool loading = true;
bool within_campus = false;

double collegelatitude = 29.5248162;
double collegelongitude = 75.6911101;
double mylatitude = 43.6544091;
double mylongitutde = -79.3782271;
double personlatitude = 0.0;
double personlongitude = 0.0;
var distance;
late BuildContext mycontext;

class location_screen extends StatefulWidget {
  const location_screen({Key? key}) : super(key: key);

  @override
  _location_screenState createState() => _location_screenState();
}

// Future<Position> _determinePosition() async {
//   bool serviceEnabled;
//   LocationPermission permission;
//
//   // Test if location services are enabled.
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     // Location services are not enabled don't continue
//     // accessing the position and request users of the
//     // App to enable the location services.
//     return Future.error('Location services are disabled.');
//   }
//
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       // Permissions are denied, next time you could try
//       // requesting permissions again (this is also where
//       // Android's shouldShowRequestPermissionRationale
//       // returned true. According to Android guidelines
//       // your App should show an explanatory UI now.
//       return Future.error('Location permissions are denied');
//     }
//   }
//
//   if (permission == LocationPermission.deniedForever) {
//     // Permissions are denied forever, handle appropriately.
//     return Future.error(
//         'Location permissions are permanently denied, we cannot request permissions.');
//   }
//
//   // When we reach here, permissions are granted and we can
//   // continue accessing the position of the device.
//   print("Starting location");
//   return await Geolocator.getCurrentPosition();
// }

Future<LocationData> _determinePosition() async {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return Future.error("Location Services Disabled");
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return Future.error("Location Permission Denied");
    }
  }

  print("Starting Location");
  _locationData = await location.getLocation();
  return _locationData;
}
_getDistance(){
  return Geolocator.distanceBetween(personlatitude, personlongitude, mylatitude, mylongitutde);
}


class _location_screenState extends State<location_screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _CheckLocation();
  }

  _CheckLocation() {
    Future<LocationData> position = _determinePosition();
    position.then((value) {
      setState(() {
        print("Got location");
        personlatitude = value.latitude!;
        personlongitude = value.longitude!;
        loading = false;
        distance = _getDistance();
        print("Distance is " + distance.toString());
        if(distance < 400)
        {
          within_campus = true;
          Navigator.pop(mycontext, true);
        }
        else
          {
            within_campus = false;
          }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    mycontext = context;
    // if(!loading)
    //   {
    //     distance = _getDistance();
    //     if(distance < 200)
    //       {
    //         Navigator.of(context).pop([true]);
    //       }
    //   }
    return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Fizzy Group location.png"),
                    fit: BoxFit.fill
                )
            ),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text('Detecting Location...', style: TextStyle(color: Colors.black, fontStyle: FontStyle.normal, decorationStyle: TextDecorationStyle.solid),),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(Icons.settings),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
                  },
                )
              ],
            ),
            body: Column(
              children: [
                Container(height: 20,width: MediaQuery.of(context).size.width,),
                Text(DateFormat("HH:mm:ss").format(DateTime.now()), style: TextStyle(fontSize: 30),),
                SizedBox(height: 5, width: MediaQuery.of(context).size.width,),
                Text(DateFormat("LLLL d, EEEE").format(DateTime.now()), style: TextStyle(fontSize: 16),),
                SizedBox(height: 20, width: MediaQuery.of(context).size.width,),
                ElevatedButton(
                    onPressed: () {
                      if(!loading)
                        {
                          setState(() {
                            loading = true;
                          });
                          _CheckLocation();
                        }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: new CircleBorder(),
                        primary: Colors.blue
                    ),
                    child: Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Colors.yellow, Colors.blue.shade700], )),
                      child: Icon(loading ? Icons.location_on : Icons.wifi_protected_setup,
                        size: 100,),
                    )
                ),
                SizedBox(height: 10, width: MediaQuery.of(context).size.width,),
                Text(loading ? "Getting Location" : (within_campus ? "You are within College Campus" : "You are outside college campus"), style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold),),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(collegelatitude, collegelongitude),
                          zoom: 15.0
                      ),
                      markers: {Marker(position: LatLng(collegelatitude, collegelongitude), markerId: MarkerId("College Location")), Marker(markerId: MarkerId("Your location"), position: LatLng(personlatitude, personlongitude))},
                      circles: {Circle(center: LatLng(collegelatitude, collegelongitude), radius: 200.0, circleId: CircleId("College Area"), fillColor: Color.fromRGBO(200, 0, 0, 0.5), strokeWidth: 4)},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    ;
  }
}

