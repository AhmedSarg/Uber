import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/presentation/resources/strings_manager.dart';

late GoogleMapController mapController;

Rx<int> expectedTime = 0.obs;
Rx<int> cost = 0.obs;
Rx<int> distance = 0.obs;
Rx<String> comment = AppStrings.chooseDestination.obs;