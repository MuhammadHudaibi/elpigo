import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MapsController extends GetxController {
  final Rx<LatLng?> _location = Rx<LatLng?>(null);

  LatLng? get location => _location.value;

  void getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Error', 'Location permissions are permanently denied.');
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        Get.snackbar('Error', 'Location permissions are denied.');
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _location.value = LatLng(position.latitude, position.longitude);
    } catch (e) {
      Get.snackbar('Error', 'Error getting location: $e');
    }
  }

  void saveLocation(double latitude, double longitude) {
    _location.value = LatLng(latitude, longitude);
  }
}