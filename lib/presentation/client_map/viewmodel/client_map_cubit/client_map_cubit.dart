import 'dart:async';

import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/domain/client_map_service.dart';
import 'package:uber/presentation/client_map/view/client_map_custom_widgets.dart';
import 'package:uber/presentation/client_map/viewmodel/client_map_viewmodel.dart';
import 'package:uber/presentation/client_map/viewmodel/client_map_cubit/client_map_state.dart';
import 'package:uber/presentation/resources/assets_manager.dart';

class ClientMapCubit extends Cubit<ClientMapState> {
  ClientMapCubit() : super(ClientMapLoadingState());

  late StreamSubscription streamSubscription;

  late Position userLocation;

  bool myLocationSelected = true;
  bool showPickupPin = false;
  bool showDestinationPin = false;

  late Marker locationMarker;

  late BitmapDescriptor gpsIcon;
  late BitmapDescriptor gpsInActiveIcon;
  late BitmapDescriptor gpsActiveIcon;
  late BitmapDescriptor pickupIcon;
  late BitmapDescriptor destinationIcon;

  Set<Marker> markers = {};

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
      gpsInActiveIcon = await getIcon(context, ImageAssets.userLocatorIcon);
      gpsActiveIcon =
          await getIcon(context, ImageAssets.userLocatorSelectedIcon);
      gpsIcon = gpsActiveIcon;
      pickupIcon = await getIcon(context, ImageAssets.pickupLocationPin);
      destinationIcon =
          await getIcon(context, ImageAssets.destinationLocationPin);
    } catch (e) {
      emit(ClientMapFailureState());
    }
  }

  Marker buildGpsMarkerIcon() {
    return Marker(
      markerId: const MarkerId('userLocation'),
      position: LatLng(userLocation.latitude, userLocation.longitude),
      icon: myLocationSelected ? gpsActiveIcon : gpsInActiveIcon,
      onTap: () {
        myLocationSelected = true;
        emit(ClientMapSuccessState());
      },
    );
  }

  void getUserLocation() {
    streamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        distanceFilter: 50,
      ),
    ).listen((position) {
      userLocation = position;
      emit(ClientMapSuccessState());
    });
  }

  void mapOnSuccess(GoogleMapController controller) {
    mapController = controller;
    markers = {buildGpsMarkerIcon()};
    pickupLocation.value =
        LatLng(userLocation.latitude, userLocation.longitude);
    destinationLocation.value =
        LatLng(userLocation.latitude, userLocation.longitude);
  }

  void mapOnMove(CameraPosition camera) {
    checkMyLocationSelected(camera);
    markers = {buildGpsMarkerIcon()};
    if (!myLocationSelected) {
      markers.add(
        Marker(
          markerId: const MarkerId("pinLocation"),
          position: camera.target,
          icon: locatorType.value == Locator.pickup
              ? pickupIcon
              : destinationIcon,
        ),
      );
    }

    if (locatorType.value == Locator.pickup) {
      pickupLocation.value = camera.target;
    } else {
      destinationLocation.value = camera.target;
    }
    emit(ClientMapSuccessState());
  }

  void checkMyLocationSelected(CameraPosition camera) {
    myLocationSelected =
        ((userLocation.latitude - camera.target.latitude.toPrecision(7))
                    .abs() <=
                0.0000005) &&
            ((userLocation.longitude - camera.target.longitude.toPrecision(7))
                    .abs() <=
                0.0000005);
    emit(ClientMapSuccessState());
  }

  void mapOnStop() async {
    await calculateTimeAndCost();
  }

  Future<void> calculateTimeAndCost() async {
    Map<String, dynamic> timeAndDistance = await ClientMapService().getTime(pickupLocation.value, destinationLocation.value);
    expectedTime.value = timeAndDistance["time"]!;
    distance.value = timeAndDistance["distance"]!;
    cost.value = (expectedTime.value * 3).round();
    polylineCode.value = timeAndDistance["polylineCode"];
  }

  void dispose() {
    mapController.dispose();
    streamSubscription.cancel();
  }

}
