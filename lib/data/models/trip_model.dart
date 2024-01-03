import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/data/global/variables.dart';
import 'package:uuid/uuid.dart';

class Trip {
  late String tripId;
  final String clientUsername;
  String? driverUsername;
  final LatLng pickupLocation;
  final LatLng destinationLocation;
  final int distance;
  final int cost;
  final int expectedTime;
  final String comment;
  String? polylineCode;
  Duration? duration;
  DateTime? startTime;
  DateTime? endTime;

  Trip({
    required this.tripId,
    required this.clientUsername,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.cost,
    required this.distance,
    required this.expectedTime,
    required this.comment,
    required this.polylineCode
  });

  Trip.request({
    required this.clientUsername,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.cost,
    required this.distance,
    required this.expectedTime,
    required this.comment,
    required this.polylineCode
  }) {
    tripId = const Uuid().v1();
    GeoPoint pickup = GeoPoint(pickupLocation.latitude, pickupLocation.longitude);
    GeoPoint destination = GeoPoint(destinationLocation.latitude, destinationLocation.longitude);
    firestore.collection("availableTrips").doc(tripId).set(
      {
        "clientUsername": clientUsername,
        "pickupLocation": pickup,
        "destinationLocation": destination,
        "cost": cost,
        "distance": distance,
        "expectedTime": expectedTime,
        "comment": comment,
        "polylineCode": polylineCode,
      },
    );
  }

  void startTrip() {
    startTime = DateTime.now();
    firestore.collection("availableTrips").doc(tripId).update({
      "startTime": startTime,
    });
  }

  void acceptTrip() {
    driverUsername = appDriver.username;
    firestore.collection("availableTrips").doc(tripId).update({
      "driverUsername": driverUsername,
    });
  }

  void endTrip() {
    endTime = DateTime.now();
    duration = endTime!.difference(startTime!);
    firestore.collection("availableTrips").doc(tripId).update({
      "endTime": endTime,
      "duration": duration!.inMinutes,
    });
  }

  void cancelTrip() {
    firestore.collection("availableTrips").doc(tripId).delete();
  }
}
