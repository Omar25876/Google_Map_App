import 'package:flutter/material.dart';
import 'package:google_maps/map/map_view.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     routes: {
       MapWidget.routeName : (context) => MapWidget(),
     },
      initialRoute:  MapWidget.routeName ,
    );
  }
}

