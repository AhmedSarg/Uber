import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uber/data/global/variables.dart';
import 'package:uber/data/models/driver_model.dart';
import 'package:uber/data/models/trip_model.dart';
import 'package:uber/presentation/driver_details/viewmodel/driver_details_cubit/driver_details_state.dart';
import 'package:uber/presentation/resources/assets_manager.dart';
import 'package:uber/presentation/resources/routes_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverDetailsCubit extends Cubit<DriverDetailsState> {
  DriverDetailsCubit() : super(DriverDetailsLoadingState());

  late Trip trip;
  Driver? driver;

  late GoogleMapController mapController;

  late StreamSubscription streamSubscription;
  late StreamSubscription endedTripStream;

  late Position userLocation;

  late BitmapDescriptor clientIcon;
  late BitmapDescriptor driverIcon;

  Future<void> init(BuildContext context, Trip trip) async {
    this.trip = trip;
    await getMarkerIcons(context);
    getUserLocation();
    await getDriverDetails();
    listenToDriverLocationChanges();
    emit(DriverDetailsSuccessState());
  }

  List<Marker> markers = [
    const Marker(
      markerId: MarkerId("clientLocation"),
    ),
    const Marker(
      markerId: MarkerId("driverLocation"),
    ),
  ];

  Future<BitmapDescriptor> getIcon(BuildContext context, String path) async {
    BitmapDescriptor icon = await MarkerIcon.svgAsset(
      assetName: path,
      context: context,
      size: 40,
    );
    return icon;
  }

  Future<void> getMarkerIcons(BuildContext context) async {
    try {
      // emit(DriverDetailsLoadingState());
      clientIcon = await getIcon(context, ImageAssets.userLocatorIcon);
      driverIcon = await getIcon(context, ImageAssets.carMap);
      print(0.1);
      // emit(DriverDetailsSuccessState());
    } catch (e) {
      print(0.2);
      emit(DriverDetailsFailureState());
    }
  }

  Marker buildClientMarkerIcon() {
    return Marker(
      markerId: const MarkerId('clientLocation'),
      position: LatLng(userLocation.latitude, userLocation.longitude),
      icon: clientIcon,
    );
  }

  Marker buildDriverMarkerIcon() {
    return Marker(
      markerId: const MarkerId('driverLocation'),
      position: LatLng(
          driver!.location!.value.latitude, driver!.location!.value.longitude),
      icon: driverIcon,
    );
  }

  void getUserLocation() {
    print(1.1);
    emit(DriverDetailsLoadingState());
    Geolocator.getCurrentPosition().then((value) {
      print(1.2);
      userLocation = value;
      markers[0] = buildClientMarkerIcon();
    });
    streamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        distanceFilter: 50,
      ),
    ).listen((position) {
      print(1.3);
      print("listening1");
      userLocation = position;
      markers[0] = buildClientMarkerIcon();
      emit(DriverDetailsSuccessState());
    });
  }

  Future<void> getDriverDetails() async {
    print(2.1);
    // emit(DriverDetailsLoadingState());
    await firestore
        .collection("drivers")
        .doc(trip.driverUsername)
        .get()
        .then((driverDoc) {
      var driverDetails = driverDoc.data()!;
      GeoPoint driverLocation = driverDetails["location"];
      driver = Driver(
        username: trip.driverUsername!,
        fullName: driverDetails["fullName"],
        phoneNumber: driverDetails["phoneNumber"],
        carModel: driverDetails["carModel"],
        carColor: driverDetails["carColor"],
        carLicense: driverDetails["carLicense"],
        rate: driverDetails["rate"],
        location: LatLng(driverLocation.latitude, driverLocation.longitude).obs,
      );
      print(2.11);
    });
    print(2.2);
    // emit(DriverDetailsSuccessState());
  }

  void listenToDriverLocationChanges() {
    firestore
        .collection("drivers")
        .doc(driver!.username)
        .snapshots
        .call()
        .listen((event) {
      print("listening2");
      GeoPoint driverNewLocation = event.data()!["location"];
      driver!.location!.value =
          LatLng(driverNewLocation.latitude, driverNewLocation.longitude);
      markers[1] = buildDriverMarkerIcon();
      emit(DriverDetailsSuccessState());
    });
  }

  void mapOnSuccess(GoogleMapController controller) {
    mapController = controller;
    listenEndTrip();
    markers[0] = buildClientMarkerIcon();
  }

  Future<void> callDriver() async {
    await launchUrl(Uri.parse("tel:${driver!.phoneNumber}"));
  }

  void shareTrip() {
    Share.share("""
    Driver Username: ${driver!.username}
    Driver Full Name: ${driver!.fullName}
    Driver Phone Number: ${driver!.phoneNumber}
    Driver Car Color: ${driver!.carColor}
    Driver Car Model: ${driver!.carModel}
    Driver Car License: ${driver!.carLicense}
    """);
  }

  void listenEndTrip() {
    endedTripStream = firestore
        .collection("availableTrips")
        .doc(trip.tripId)
        .snapshots
        .call()
        .listen(
      (document) {
        var tripData = document.data()!;
        if (tripData["endTime"] != null) {
          trip.startTime = DateTime.parse(tripData["startTime"].toDate().toString()) ;
          trip.endTime = DateTime.parse(tripData["endTime"].toDate().toString());
          trip.duration = Duration(minutes: tripData["duration"]);
          Get.offAllNamed(Routes.recieptRoute, arguments: [trip]);
        }
      },
    );
  }

  void dispose() {
    mapController.dispose();
    streamSubscription.cancel();
    endedTripStream.cancel();
  }
}
