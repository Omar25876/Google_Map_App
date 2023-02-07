import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapWidget extends StatefulWidget {
  static const String routeName = 'Map';

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Location location = new Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _location;


  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  void getPermissionEnabled() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }
  }

  void getpermissionStutus() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        
      }
    }

    marks.add(Marker(markerId: MarkerId("1"),position: LatLng(_kGooglePlex.target.latitude, _kGooglePlex.target.longitude)));
    setState(() {});
    final GoogleMapController controller =await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));

    location.onLocationChanged.listen((LocationData locationData) {
      _location = locationData;
      marks.add(Marker(markerId: MarkerId("${marks.length+1}"),position: LatLng(_kLake.target.latitude, _kLake.target.longitude)));

    });
  }
  Set<Marker> marks = {};
  @override
  void initState() {
    super.initState();
    getPermissionEnabled();
    getpermissionStutus();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: marks,
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        onPressed: _goToTheLake,
        label: const Text('Go To Location',style:TextStyle(
          fontSize: 21
        ),),
        icon: const Icon(Icons.arrow_upward_outlined,size: 32),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}




