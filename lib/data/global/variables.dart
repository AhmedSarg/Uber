import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/presentation/selection/model/selection_model.dart';
import 'package:uber/presentation/user_authentication/model/user_authentication_model.dart';

late FirebaseFirestore firestore;

class AppClient {
  late final String username;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? dateOfBirth;
  Gender? gender;
  Rx<LatLng?> location = Rx<LatLng?>(null);

  AppClient._internal();

  static final AppClient _singleton = AppClient._internal();

  factory AppClient.setData({
    required username,
    required AuthenticationType authenticationType,
    fullName,
    email,
    phoneNumber,
    dateOfBirth,
    gender,
  }) {
    _singleton.username = username;
    if (authenticationType == AuthenticationType.login) {
      firestore.collection("clients").doc(username).get().then(
        (value) {
          var client = value.data()!;
          GeoPoint clientLocation = client["location"];
          _singleton.fullName = client["fullName"];
          _singleton.email = client["email"];
          _singleton.phoneNumber = client["phoneNumber"];
          _singleton.dateOfBirth = client["dateOfBirth"];
          _singleton.gender =
              client["gender"] == "male" ? Gender.male : Gender.female;
          _singleton.location.value =
              LatLng(clientLocation.latitude, clientLocation.longitude);
        },
      );
    } else {
      _singleton.fullName = fullName;
      _singleton.email = email;
      _singleton.phoneNumber = phoneNumber;
      _singleton.dateOfBirth = dateOfBirth;
      _singleton.gender = gender;
      print(0);
      Geolocator.getCurrentPosition().then(
        (value) {
          print(1);
          GeoPoint position = GeoPoint(value.latitude, value.longitude);
          print(2);
          _singleton.location.value =
              LatLng(position.latitude, position.longitude);
          print(3);
          firestore.collection("clients").doc(username).set(
            {
              "fullName": fullName,
              "email": email,
              "phoneNumber": phoneNumber,
              "dateOfBirth": dateOfBirth,
              "gender": gender == Gender.male ? "male" : "female",
              "location": position,
            },
          );
        },
      );
    }
    return _singleton;
  }

  factory AppClient() {
    return _singleton;
  }
}

// var appClient = AppClient.setData(username: "AhmedSarg", authenticationType: AuthenticationType.login);

late AppClient appClient;

class AppDriver {
  late final String username;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? dateOfBirth;
  Gender? gender;
  String? address;
  String? carModel;
  String? carColor;
  String? carLicense;
  double? rate;
  Rx<LatLng?> location = Rx<LatLng?>(null);

  AppDriver._internal();

  static final AppDriver _singleton = AppDriver._internal();

  factory AppDriver.setData({
    required username,
  }) {
    _singleton.username = username;
    firestore.collection("drivers").doc(username).get().then(
      (value) {
        var driver = value.data()!;
        GeoPoint driverLocation = driver["location"];
        _singleton.fullName = driver["fullName"];
        _singleton.email = driver["email"];
        _singleton.phoneNumber = driver["phoneNumber"];
        _singleton.dateOfBirth = driver["dateOfBirth"];
        _singleton.gender =
            driver["gender"] == "male" ? Gender.male : Gender.female;
        _singleton.address = driver["address"];
        _singleton.carModel = driver["carModel"];
        _singleton.carColor = driver["carColor"];
        _singleton.carLicense = driver["carLicense"];
        _singleton.rate = driver["rate"];
        _singleton.location.value =
            LatLng(driverLocation.latitude, driverLocation.longitude);
      },
    );
    return _singleton;
  }

  factory AppDriver() {
    return _singleton;
  }
}

// var appDriver = AppDriver.setData(username: "sherifmohamed");

late AppDriver appDriver;

Selection userType = Selection.user;
