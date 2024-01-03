import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/data/global/variables.dart';
import 'package:uber/presentation/user_authentication/model/user_authentication_model.dart';

class Client {
  final String username;
  String? fullName;
  String? phoneNumber;
  String? dateOfBirth;
  Gender? gender;
  String? email;
  Rx<LatLng?> location = Rx<LatLng?>(null);

  Client({
    required this.username,
    required this.fullName,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.email,
    required this.location,
  });

  Client.getFromFirebase({
    required this.username,
  }) {
    print(3.11);
    firestore.collection("clients").doc(username).get().then((value) {
      print(3.111);
      var clientData = value.data()!;
      GeoPoint clientLocation = clientData["location"];
      fullName = clientData["fullName"];
      phoneNumber = clientData["phoneNumber"];
      dateOfBirth = clientData["dateOfBirth"];
      gender = clientData["gender"] == "male" ? Gender.male : Gender.female;
      email = clientData["email"];
      location.value = LatLng(clientLocation.latitude, clientLocation.longitude);
      print(3.112);
    });
    print(3.12);
  }
}
