import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/presentation/client_map/view/client_map_custom_widgets.dart';

const LatLng defaultLocation = LatLng(31.1803616, 30.4773837);

late GoogleMapController mapController;

Rx<Locator> locatorType = Locator.pickup.obs;

Rx<LatLng> pickupLocation = defaultLocation.obs;
Rx<LatLng> destinationLocation = defaultLocation.obs;

Rx<int> expectedTime = 0.obs;
Rx<int> cost = 0.obs;
Rx<int> distance = 0.obs;
Rx<String> polylineCode = "".obs;

/// Time and Cost Algorithm for Backup ///
// double calculateDistance(LatLng pickup, LatLng destination) {
//   double lat1 = pickup.latitude;
//   double lon1 = pickup.longitude;
//   double lat2 = destination.latitude;
//   double lon2 = destination.longitude;
//
//   const R = 6371.0; // Earth radius in kilometers
//
//   final lat1Rad = radians(lat1);
//   final lon1Rad = radians(lon1);
//   final lat2Rad = radians(lat2);
//   final lon2Rad = radians(lon2);
//
//   final dlat = lat2Rad - lat1Rad;
//   final dlon = lon2Rad - lon1Rad;
//
//   final a = sin(dlat / 2) * sin(dlat / 2) +
//       cos(lat1Rad) * cos(lat2Rad) * sin(dlon / 2) * sin(dlon / 2);
//
//   final c = 2 * atan2(sqrt(a), sqrt(1 - a));
//
//   final distance = R * c; // Distance in kilometers
//
//   return distance;
// }
//
// double radians(double degrees) {
//   return degrees * (pi / 180.0);
// }
//
// int estimateTravelTime(LatLng pickup, LatLng destination) {
//
//   double distance = calculateDistance(pickup, destination);
//
//   const double averageSpeed = 10.0;
//   // Calculate travel time = distance / speed
//   double travelTimeHours = distance / averageSpeed;
//
//   // Convert travel time to seconds
//   int travelTimeMinutes = (travelTimeHours * 60).round();
//
//   return travelTimeMinutes;
// }
//
// void calculateTimeAndCost() {
//   int time = estimateTravelTime(pickupLocation.value, destinationLocation.value);
//   expectedTime.value = time == 0 ? AppStrings.chooseDestination : "$time Minutes";
//   cost.value = time == 0 ? AppStrings.chooseDestination : "${time * 3} L.E";
// }
