import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class MapScreen extends StatefulWidget {
  final LatLng initialLocation;
  final Function(LatLng) onSave;

  MapScreen({required this.initialLocation, required this.onSave});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  late LatLng _currentLocation;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 82, 140, 75),
        title: Text('Pilih Lokasi', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () {
              widget.onSave(_currentLocation);
              Navigator.of(context).pop();
            },
            child: Text('Simpan', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            onCameraMove: (CameraPosition newPosition) {
              _currentLocation = newPosition.target;
            },
          ),
          Positioned(
              top: MediaQuery.of(context).size.height / 2 - 90,
              left: MediaQuery.of(context).size.width / 2 - 25,
              child: Icon(Icons.location_on, size: 50, color: Colors.red),
            ),
        ],
      ),
    );
  }
}