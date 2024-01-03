import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:uber/presentation/resources/color_manager.dart';
import 'package:uber/presentation/resources/font_manager.dart';
import 'package:uber/presentation/resources/strings_manager.dart';
import 'package:uber/presentation/resources/values_manager.dart';
import 'package:uber/presentation/client_map/viewmodel/client_map_viewmodel.dart';

enum Locator { pickup, destination }

class LocatorSelector extends StatelessWidget {
  const LocatorSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              LocatorButton(type: Locator.pickup),
              LocatorButton(type: Locator.destination),
            ],
          ),
        ],
      ),
    );
  }
}

class LocatorButton extends StatelessWidget {
  const LocatorButton({super.key, required this.type});

  final Locator type;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Obx(
        () => TextButton(
        onPressed: () {
          locatorType.value = type;
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: type == Locator.pickup
                    ? LatLng(pickupLocation.value.latitude,
                        pickupLocation.value.longitude)
                    : LatLng(destinationLocation.value.latitude,
                        destinationLocation.value.longitude),
                zoom: AppSize.s18,
              ),
            ),
          );
        },
        style: TextButton.styleFrom(
          fixedSize: Size((width - 42) / 2, 30),
          backgroundColor: type == locatorType.value
              ? ColorManager.primary
              : ColorManager.white,
          foregroundColor: type == locatorType.value
              ? ColorManager.white
              : ColorManager.border,
          shape: RoundedRectangleBorder(
            borderRadius: type == Locator.pickup
                ? const BorderRadius.horizontal(
                    left: Radius.circular(10),
                  )
                : const BorderRadius.horizontal(
                    right: Radius.circular(10),
                  ),
            side: BorderSide(
              color: ColorManager.border,
            ),
          ),
        ),
        child: Text(
          type == Locator.pickup ? AppStrings.pickup : AppStrings.destination,
          style: const TextStyle(
            fontFamily: FontConstants.cascadia,
          ),
        ),
      ),
    );
  }
}
