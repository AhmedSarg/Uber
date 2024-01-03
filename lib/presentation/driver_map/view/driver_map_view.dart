import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/data/global/variables.dart';
import 'package:uber/presentation/driver_map/viewmodel/driver_map_cubit/driver_map_cubit.dart';
import 'package:uber/presentation/driver_map/viewmodel/driver_map_cubit/driver_map_state.dart';
import 'package:uber/presentation/driver_map/viewmodel/driver_map_viewmodel.dart';
import 'package:uber/presentation/resources/assets_manager.dart';
import 'package:uber/presentation/resources/color_manager.dart';
import 'package:uber/presentation/resources/routes_manager.dart';
import 'package:uber/presentation/resources/strings_manager.dart';
import 'package:uber/presentation/resources/styles_manager.dart';
import 'package:uber/presentation/resources/values_manager.dart';
import 'package:uber/presentation/resources/widgets.dart';

class DriverMapView extends StatelessWidget {
  DriverMapView({super.key});

  late DriverMapCubit viewModel;

  @override
  Widget build(BuildContext context) {
    // print("screen rebuilt");
    print(appDriver.email);
    print(appDriver.fullName);
    print(appDriver.username);
    print(appDriver.location);
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height / 4;
    viewModel = BlocProvider.of<DriverMapCubit>(context);
    viewModel.getMarkerIcons(context);
    viewModel.getDriverLocation();
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: SafeArea(
        child: BlocBuilder<DriverMapCubit, DriverMapState>(
          builder: (context, state) {
            // print("bloc rebuild");
            // print(state.runtimeType);
            if (state is DriverMapLoadingState) {
              return Container(
                color: ColorManager.white.withOpacity(0.6),
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(bottom: h + AppSize.s62),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: ColorManager.primary,
                  ),
                ),
              );
            } else if (state is DriverMapSuccessState) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: const EdgeInsets.only(bottom: AppSize.s62),
                    child: GoogleMap(
                      onMapCreated: (controller) {
                        viewModel.mapOnSuccess(controller);
                      },
                      onTap: (location) {
                        viewModel.selectedTrip.value = null;
                        viewModel.updateMap();
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          viewModel.driverLocation.latitude,
                          viewModel.driverLocation.longitude,
                        ),
                        zoom: AppSize.s18,
                      ),
                      markers: viewModel.markers,
                      polylines: viewModel.polylines,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: AppSize.s20, top: AppSize.s10),
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          splashRadius: AppSize.s20,
                          style: IconButton.styleFrom(
                              backgroundColor: ColorManager.darkGrey),
                          padding: const EdgeInsets.only(right: AppSize.s2),
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: ColorManager.white,
                            size: AppSize.s20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: AppSize.s20, top: AppSize.s10),
                        child: IconButton(
                          onPressed: () {
                            mapController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: LatLng(
                                    viewModel.driverLocation.latitude,
                                    viewModel.driverLocation.longitude,
                                  ),
                                  zoom: AppSize.s18,
                                ),
                              ),
                            );
                          },
                          splashRadius: AppSize.s20,
                          style: IconButton.styleFrom(
                              backgroundColor: ColorManager.darkGrey),
                          icon: Icon(
                            Icons.gps_fixed_rounded,
                            color: ColorManager.white,
                            size: AppSize.s20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Container(
                color: ColorManager.white.withOpacity(0.6),
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(bottom: h + AppSize.s62),
                child: const Center(
                  child: Text("Error"),
                ),
              );
            }
          },
        ),
      ),
      bottomSheet: Obx(
        () => Container(
          width: w,
          height: AppSize.s62 + (viewModel.selectedTrip.value == null ? 0 : h),
          decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: viewModel.selectedTrip.value == null
                  ? BorderRadius.zero
                  : const BorderRadius.vertical(
                      top: Radius.circular(AppSize.s20)),
              border:
                  Border.all(color: ColorManager.border, width: AppSize.s1)),
          child: Column(
            children: [
              viewModel.selectedTrip.value == null || viewModel.selectedClient.value!.fullName == null
                  ? const SizedBox()
                  : Container(
                      height: h,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p20),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppPadding.p10),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: AppPadding.p10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: AppPadding.p10),
                                    child: CircleAvatar(
                                      backgroundColor: ColorManager.primary,
                                      radius: 35,
                                      child: SvgPicture.asset(
                                        ImageAssets.userLocatorIcon,
                                        width: 70,
                                        height: 70,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        viewModel
                                            .selectedClient.value!.fullName!,
                                        style: getRegularStyle(
                                          color: ColorManager.primary,
                                          fontSize: AppSize.s18,
                                        ),
                                      ),
                                      Text(
                                        "@${viewModel.selectedClient.value!.username}",
                                        style: getRegularStyle(
                                          color: ColorManager.border,
                                          fontSize: AppSize.s12,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: AppPadding.p6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppStrings.distance,
                                    style: getSemiLightStyle(
                                      color: ColorManager.black,
                                      fontSize: AppSize.s14,
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      viewModel.selectedTrip.value!.distance ==
                                              0
                                          ? AppStrings.chooseDestination
                                          : "${(viewModel.selectedTrip.value!.distance / 1000).toStringAsFixed(1)} ${AppStrings.distanceUnit}",
                                      style: getSemiLightStyle(
                                        color: ColorManager.border,
                                        fontSize: AppSize.s12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: AppPadding.p6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppStrings.cost,
                                    style: getSemiLightStyle(
                                      color: ColorManager.black,
                                      fontSize: AppSize.s14,
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      viewModel.selectedTrip.value!.cost == 0
                                          ? AppStrings.chooseDestination
                                          : "${viewModel.selectedTrip.value!.cost} ${AppStrings.costUnit}",
                                      style: getSemiLightStyle(
                                        color: ColorManager.border,
                                        fontSize: AppSize.s12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppPadding.p6,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppStrings.expectedTime,
                                    style: getSemiLightStyle(
                                      color: ColorManager.black,
                                      fontSize: AppSize.s14,
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      viewModel.selectedTrip.value!
                                                  .expectedTime ==
                                              0
                                          ? AppStrings.chooseDestination
                                          : "${viewModel.selectedTrip.value!.expectedTime} ${expectedTime.value == 1 ? AppStrings.expectedTimeUnit.substring(0, 6) : AppStrings.expectedTimeUnit}",
                                      style: getSemiLightStyle(
                                        color: ColorManager.border,
                                        fontSize: AppSize.s12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.zero,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${AppStrings.comment}:",
                                    style: getSemiLightStyle(
                                      color: ColorManager.black,
                                      fontSize: AppSize.s14,
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      viewModel.selectedTrip.value!.comment ==
                                              ""
                                          ? AppStrings.noComment
                                          : viewModel
                                              .selectedTrip.value!.comment,
                                      style: getSemiLightStyle(
                                        color: ColorManager.border,
                                        fontSize: AppSize.s12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              viewModel.selectedTrip.value == null
                  ? button(
                      text: AppStrings.chooseATrip,
                      context: context,
                      onPressed: null,
                    )
                  : button(
                      text: AppStrings.accept,
                      context: context,
                      onPressed: () {
                        viewModel.selectedTrip.value!.acceptTrip();
                        Get.offAllNamed(Routes.clientDetailsRoute, arguments: [viewModel.selectedTrip.value]);
                        viewModel.selectedTrip.value = null;
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
