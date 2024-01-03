import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Driver {
  final String username;
  final String fullName;
  final String phoneNumber;
  final String carModel;
  final String carColor;
  final String carLicense;
  final double rate;
  Rx<LatLng>? location;

  Driver({
    required this.username,
    required this.fullName,
    required this.phoneNumber,
    required this.carModel,
    required this.carColor,
    required this.carLicense,
    required this.rate,
    required this.location
  });
}
