import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flexible_polyline_dart/flutter_flexible_polyline.dart';
import 'package:flexible_polyline_dart/latlngz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/data/global/variables.dart';
import 'package:uber/data/models/client_model.dart';
import 'package:uber/data/models/trip_model.dart';
import 'package:uber/presentation/client_details/viewmodel/client_details_cubit/client_details_state.dart';
import 'package:uber/presentation/resources/assets_manager.dart';
import 'package:uber/presentation/resources/color_manager.dart';
import 'package:uber/presentation/user_authentication/model/user_authentication_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientDetailsCubit extends Cubit<ClientDetailsState> {
  ClientDetailsCubit() : super(ClientDetailsLoadingState());

  late Trip trip;
  Client? client;

  late GoogleMapController mapController;

  late StreamSubscription streamSubscription;

  static const LatLng defaultLocation = LatLng(31.1803616, 30.4773837);
  late Position userLocation;
  late BitmapDescriptor pickupPinIcon;
  late BitmapDescriptor destinationPinIcon;
  late BitmapDescriptor driverIcon;

  Future<void> init(BuildContext context, Trip trip) async {
    this.trip = trip;
    createPolylines();
    print(1);
    await getMarkerIcons(context);
    print(2);
    await getClientDetails();
    print(3);
    print(trip.pickupLocation);
    print(trip.destinationLocation);
    markers.add(
      Marker(
          markerId: const MarkerId("pickupPin"),
          position: trip.pickupLocation,
          icon: pickupPinIcon
      ),
    );
    markers.add(
      Marker(
        markerId: const MarkerId("destinationPin"),
        position: trip.destinationLocation,
        icon: destinationPinIcon
      ),
    );
    getUserLocation();
    print(4);
    // emit(ClientDetailsSuccessState());
  }

  List<Marker> markers = [
    const Marker(
      markerId: MarkerId("clientLocation"),
    ),
  ];
  Set<Polyline> polylines = {};

  Rx<bool> started = false.obs;

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
      driverIcon = await getIcon(context, ImageAssets.carMap);
      pickupPinIcon = await getIcon(context, ImageAssets.pickupLocationPin);
      destinationPinIcon =
          await getIcon(context, ImageAssets.destinationLocationPin);
    } catch (e) {
      // emit(ClientDetailsFailureState());
    }
  }

  Marker buildDriverMarkerIcon() {
    return Marker(
      markerId: const MarkerId('driverLocation'),
      position: LatLng(userLocation.latitude, userLocation.longitude),
      icon: driverIcon,
    );
  }

  void getUserLocation() {
    print(0.002);
    Geolocator.getCurrentPosition().then((value) {
      userLocation = value;
      print(userLocation);
      markers[0] = buildDriverMarkerIcon();
      emit(ClientDetailsSuccessState());
    });
    streamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        distanceFilter: 50,
      ),
    ).listen((position) {
      userLocation = position;
      print(userLocation);
      markers[0] = buildDriverMarkerIcon();
      emit(ClientDetailsSuccessState());
    });
  }

  Future<void> getClientDetails() async {
    await firestore
        .collection("clients")
        .doc(trip.clientUsername)
        .get()
        .then((clientDoc) {
      var clientDetails = clientDoc.data()!;
      GeoPoint clientLocation = clientDetails["location"];
      client = Client(
        username: trip.clientUsername,
        fullName: clientDetails["fullName"],
        phoneNumber: clientDetails["phoneNumber"],
        location: LatLng(clientLocation.latitude, clientLocation.longitude).obs,
        dateOfBirth: clientDetails["dateOfBirth"],
        gender: clientDetails["gender"] == "male" ? Gender.male : Gender.female,
        email: clientDetails["email"],
      );
    });
  }

  void mapOnSuccess(GoogleMapController controller) {
    mapController = controller;
    started.value = false;
    markers[0] = buildDriverMarkerIcon();
  }

  Future<void> callClient() async {
    await launchUrl(Uri.parse("tel:${client!.phoneNumber}"));
  }

  createPolylines() {
    polylines.clear();
    String polylineCode = trip.polylineCode!;
    List<LatLngZ> polylineMatrix = FlexiblePolyline.decode(polylineCode);
    List<LatLng> resultedPolylineMatrix = [];
    for (var polyline in polylineMatrix) {
      resultedPolylineMatrix.add(LatLng(
        polyline.lat,
        polyline.lng,
      ));
    }
    polylines.add(
      Polyline(
          polylineId: const PolylineId("route"),
          points: resultedPolylineMatrix,
          color: ColorManager.primary,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap),
    );
  }

  void startTrip() {
    trip.startTrip();
    started.value = true;
  }

  void endTrip() {
    trip.endTrip();
  }

  void cancelTrip() {
    trip.cancelTrip();
  }

  void dispose() {
    mapController.dispose();
    polylines.clear();
    streamSubscription.cancel();
  }
}
