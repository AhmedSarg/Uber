import 'dart:async';

import 'package:get/get.dart';
import 'package:uber/data/global/variables.dart';
import 'package:uber/data/models/trip_model.dart';
import 'package:uber/presentation/resources/routes_manager.dart';
class DriverSearchViewModel {
  late Timer timer;
  bool foundDriver = false;
  late Trip trip;
  DriverSearchViewModel({required this.trip}) {
    timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        firestore.collection("availableTrips").doc(trip.tripId).get().then(
          (value) {
            String? driverUsername = value.data()!["driverUsername"];
            if (driverUsername != null) {
              trip.driverUsername = driverUsername;
              Get.offAllNamed(Routes.driverDetailsRoute, arguments: [trip]);
            }
          },
        );
      },
    );
  }
  void dispose() {
    timer.cancel();
  }
}
