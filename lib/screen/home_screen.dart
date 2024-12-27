import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CameraPosition initialPosition = CameraPosition(
    target: LatLng(
      37.5214,
      126.9246,
    ),
    zoom: 15,
  );

  late final GoogleMapController controller;

  checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      throw Exception('위치 기능을 활성화 해주세요');
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();
    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();
    }

    if (checkedPermission != LocationPermission.always &&
        checkedPermission != LocationPermission.whileInUse) {
      throw Exception('위치 권한을 허가 해주세요');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '오늘도 출근',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: myLocationPressed,
            icon: Icon(
              Icons.my_location,
            ),
            color: Colors.blue,
          ),
        ],
      ),
      body: FutureBuilder(
        future: checkPermission(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return Column(
            children: [
              Expanded(
                flex: 2,
                child: GoogleMap(
                  initialCameraPosition: initialPosition,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    this.controller = controller;
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId('123'),
                      position: LatLng(
                        37.5214,
                        126.9246,
                      ),
                    ),
                  },
                  circles: {
                    Circle(
                      circleId: CircleId('inDistance'),
                      center: LatLng(
                        37.5214,
                        126.9246,
                      ),
                      radius: 100,
                      fillColor: Colors.blue.withAlpha(128),
                      strokeColor: Colors.blue,
                      strokeWidth: 1,
                    ),
                  },
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timelapse_outlined,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                      child: Text(
                        '출근하기',
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void myLocationPressed() async {
    final location = await Geolocator.getCurrentPosition();
    controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
          location.latitude,
          location.longitude,
        ),
      ),
    );
  }
}
