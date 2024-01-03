import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/data/global/variables.dart';
import 'package:uber/data/models/client_model.dart';
import 'package:uber/data/models/trip_model.dart';
import 'package:uber/presentation/driver_map/viewmodel/driver_map_viewmodel.dart';
import 'package:uber/presentation/driver_map/viewmodel/driver_map_cubit/driver_map_state.dart';
import 'package:uber/presentation/resources/assets_manager.dart';
import 'package:uber/presentation/resources/color_manager.dart';
import 'package:uber/presentation/resources/values_manager.dart';

class DriverMapCubit extends Cubit<DriverMapState> {
  DriverMapCubit() : super(DriverMapLoadingState());

  late StreamSubscription streamSubscription;
  late StreamSubscription clientsStream;

  late Position driverLocation;

  late BitmapDescriptor destinationActivePinIcon;
  late BitmapDescriptor destinationInActivePinIcon;
  late BitmapDescriptor clientActiveIcon;
  late BitmapDescriptor clientInActiveIcon;
  late BitmapDescriptor driverIcon;

  Set<Marker> markers = {};

  Set<Polyline> polylines = {};

  List<Trip> trips = [];
  List<Client> clients = [];

  Rx<Trip?> selectedTrip = Rx<Trip?>(null);
  Rx<Client?> selectedClient = Rx<Client?>(null);

  Future<BitmapDescriptor> getIcon(BuildContext context, String path) async {
    BitmapDescriptor icon = await MarkerIcon.svgAsset(
      assetName: path,
      context: context,
      size: 40,
    );
    return icon;
  }

  void getMarkerIcons(BuildContext context) async {
    try {
      driverIcon = await getIcon(context, ImageAssets.carMap);
      destinationActivePinIcon = await getIcon(context, ImageAssets.destinationLocationPin);
      destinationInActivePinIcon = await getIcon(context, ImageAssets.pickupLocationPin);
      clientActiveIcon =
          await getIcon(context, ImageAssets.userLocatorSelectedIcon);
      clientInActiveIcon =
          await getIcon(context, ImageAssets.userLocatorIcon);
    } catch (e) {
      emit(DriverMapFailureState());
    }
  }

  Marker buildGpsMarkerIcon() {
    return Marker(
      markerId: const MarkerId('driverLocation'),
      position: LatLng(driverLocation.latitude, driverLocation.longitude),
      icon: driverIcon,
    );
  }

  void getDriverLocation() {
    streamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        distanceFilter: 50,
      ),
    ).listen((position) {
      driverLocation = position;
      emit(DriverMapSuccessState());
    });
  }

  void mapOnSuccess(GoogleMapController controller) {
    mapController = controller;
    markers = {buildGpsMarkerIcon()};
    getAvailableTrips();
    emit(DriverMapSuccessState());
  }

  void getAvailableTrips() {
    clientsStream =
        firestore.collection("availableTrips").snapshots.call().listen(
      (fireStoreTrips) {
        trips.clear();
        clients.clear();
        for (var fireStoreTrip in fireStoreTrips.docs) {
          var tripData = fireStoreTrip.data();
          if (tripData["driverUsername"] == null) {
            GeoPoint tripPickup = tripData["pickupLocation"];
            GeoPoint tripDestination = tripData["destinationLocation"];
            Trip trip = Trip(
              tripId: fireStoreTrip.id,
              clientUsername: tripData["clientUsername"],
              pickupLocation: LatLng(tripPickup.latitude, tripPickup.longitude),
              destinationLocation:
                  LatLng(tripDestination.latitude, tripDestination.longitude),
              cost: tripData["cost"],
              expectedTime: tripData["expectedTime"],
              distance: tripData["distance"],
              comment: tripData["comment"],
              polylineCode: tripData["polylineCode"],
            );
            trips.add(trip);
            clients.add(Client.getFromFirebase(username: trip.clientUsername));
          }
        }
        updateMap();
      },
    );
  }

  void updateMap() {
    polylines.clear();
    markers = {markers.elementAt(0)};
    for (var trip in trips) {
      polylines.add(
        Polyline(
          polylineId: PolylineId(trip.tripId),
          points: [trip.pickupLocation, trip.destinationLocation],
          width: 5,
          color: trip == selectedTrip.value
              ? ColorManager.secondary
              : ColorManager.primary,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
          consumeTapEvents: true,
          patterns: [
            PatternItem.dash(70),
            PatternItem.gap(15),
          ],
          onTap: () async {
            selectedTrip.value = trip;
            selectedClient.value = clients[trips.indexOf(trip)];
            mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(
                    (trip.pickupLocation.latitude +
                            trip.destinationLocation.latitude) /
                        2,
                    (trip.pickupLocation.longitude +
                            trip.destinationLocation.longitude) /
                        2,
                  ),
                  zoom: AppSize.s15 - (trip.distance / 10000),
                ),
              ),
            );
            updateMap();
          },
        ),
      );
      markers.add(
        Marker(
          markerId: MarkerId("${trip.tripId}-pickup"),
          position: LatLng(trip.pickupLocation.latitude, trip.pickupLocation.longitude),
          icon: trip == selectedTrip.value ? clientActiveIcon : clientInActiveIcon,
        ),
      );
      markers.add(
        Marker(
          markerId: MarkerId("${trip.tripId}-destination"),
          position: LatLng(trip.destinationLocation.latitude, trip.destinationLocation.longitude),
          icon: trip == selectedTrip.value ? destinationActivePinIcon : destinationInActivePinIcon,
        ),
      );
    }
    emit(DriverMapSuccessState());
  }

  void dispose() {
    mapController.dispose();
    streamSubscription.cancel();
    clientsStream.cancel();
  }
}
