import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:foodie_list/vm/database_handler.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latlng;

class Geolocate extends StatefulWidget {
  const Geolocate({super.key});

  @override
  State<Geolocate> createState() => _GeolocateState();
}

class _GeolocateState extends State<Geolocate> {
  late DatabaseHandler handler;
  late MapController mapController;
  late double latData; // 위도 데이터
  late double longData; // 경도 데이터

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    mapController = MapController();
    final arguments = Get.arguments as List<dynamic>;
    latData = arguments[0];
    longData = arguments[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Location',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/back.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: latlng.LatLng(latData, longData),
          initialZoom: 17.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: latlng.LatLng(latData, longData),
                child: const Column(
                  children: [
                    Icon(
                      Icons.pin_drop,
                      size: 50,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
