import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/maps_controller.dart';

// ignore: use_key_in_widget_constructors
class MapsView extends StatelessWidget {
  final MapsController mapsController = Get.put(MapsController());

  @override
  Widget build(BuildContext context) {
    mapsController.getLocation();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Lokasi'),
      ),
      body: Obx(() {
        if (mapsController.location == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return MapView(center: mapsController.location!, controller: mapsController);
      }),
    );
  }
}

class MapView extends StatefulWidget {
  final LatLng center;
  final MapsController controller;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  MapView({required this.center, required this.controller});

  @override
  // ignore: library_private_types_in_public_api
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late LatLng _mapCenter;
  final ValueNotifier<LatLng> _mapCenterNotifier = ValueNotifier(LatLng(0, 0));

  @override
  void initState() {
    super.initState();
    _mapCenter = widget.center;
    _mapCenterNotifier.value = _mapCenter;
  }

  void _onCameraMove(CameraPosition position) {
    _mapCenterNotifier.value = position.target;
    widget.controller.saveLocation(position.target.latitude, position.target.longitude);
  }

  void _saveLocation() {
    LatLng savedLocation = _mapCenterNotifier.value;
    widget.controller.saveLocation(savedLocation.latitude, savedLocation.longitude);
    Get.back();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor:  Color.fromARGB(255,151, 182, 153),content: Text('Berhasil menandai lokasi', style: GoogleFonts.poppins())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.center,
            zoom: 15.0,
          ),
          myLocationEnabled: true,
          onCameraMove: _onCameraMove,
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 90,
          left: MediaQuery.of(context).size.width / 2 - 25,
          child: Icon(Icons.location_on, size: 50, color: Colors.red),
        ),
        ValueListenableBuilder(
          valueListenable: _mapCenterNotifier,
          builder: (context, value, child) {
            return Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Latitude: ${value.latitude.toStringAsFixed(6)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Longitude: ${value.longitude.toStringAsFixed(6)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 16,
          left: MediaQuery.of(context).size.width / 2 - 60,
          child: ElevatedButton.icon(
            onPressed: _saveLocation,
            icon: Icon(Icons.save),
            label: Text("Simpan"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
