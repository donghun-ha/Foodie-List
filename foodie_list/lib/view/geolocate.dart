import 'package:flutter/material.dart';

class Geolocate extends StatefulWidget {
  const Geolocate({super.key});

  @override
  State<Geolocate> createState() => _GeolocateState();
}

class _GeolocateState extends State<Geolocate> {
  // Property
  late double latData; // 위도 데이터
  late double longData; // 경도 데이터
  late bool canRun;
  // Controller.text = latData.toString();

  @override
  void initState() {
    super.initState();
    canRun = false;
    checkLocationPermission();
  }

  checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      getCurrentLocation();
    }
  }

  getCurrentLocation() async {
    // 학원 위치 : 37.4973294 / 127.0293198
    Position position = await Geolocator.getCurrentPosition();
    currentPosition = position;
    canRun = true;
    latData = currentPosition.latitude;
    longData = currentPosition.longitude;
    print("lat:$latData, long:$longData");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('맛집 위치'),
      ),
    );
  }
}
