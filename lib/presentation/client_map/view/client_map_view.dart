import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/data/global/variables.dart';
import 'package:uber/data/models/trip_model.dart';
import 'package:uber/presentation/client_map/view/client_map_custom_widgets.dart';
import 'package:uber/presentation/client_map/viewmodel/client_map_viewmodel.dart';
import 'package:uber/presentation/client_map/viewmodel/client_map_cubit/client_map_cubit.dart';
import 'package:uber/presentation/client_map/viewmodel/client_map_cubit/client_map_state.dart';
import 'package:uber/presentation/resources/color_manager.dart';
import 'package:uber/presentation/resources/routes_manager.dart';
import 'package:uber/presentation/resources/strings_manager.dart';
import 'package:uber/presentation/resources/styles_manager.dart';
import 'package:uber/presentation/resources/values_manager.dart';
import 'package:uber/presentation/resources/widgets.dart';

class ClientMapView extends StatelessWidget {
  ClientMapView({super.key});
  late ClientMapCubit viewModel;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print("screen rebuilt");
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height / 4;
    viewModel = BlocProvider.of<ClientMapCubit>(context);
    viewModel.getMarkerIcons(context);
    viewModel.getUserLocation();
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: SafeArea(
        child: BlocBuilder<ClientMapCubit, ClientMapState>(
          builder: (context, state) {
            // print("bloc rebuild");
            // print(state.runtimeType);
            print(appClient.email);
            print(appClient.fullName);
            print(appClient.username);
            print(appClient.location);
            if (state is ClientMapLoadingState) {
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
            } else if (state is ClientMapSuccessState) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.only(bottom: h + AppSize.s62),
                    child: GoogleMap(
                      onMapCreated: (controller) {
                        viewModel.mapOnSuccess(controller);
                      },
                      onCameraMove: (camera) {
                        viewModel.mapOnMove(camera);
                      },
                      onCameraIdle: () {
                        viewModel.mapOnStop();
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          viewModel.userLocation.latitude,
                          viewModel.userLocation.longitude,
                        ),
                        zoom: AppSize.s18,
                      ),
                      markers: viewModel.markers,
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
                                      viewModel.userLocation.latitude,
                                      viewModel.userLocation.longitude),
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
      bottomSheet: Container(
        width: w,
        height: h + AppSize.s62,
        decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(AppSize.s20)),
            border: Border.all(color: ColorManager.border, width: AppSize.s1)),
        child: Column(
          children: [
            Container(
              height: h,
              padding: const EdgeInsets.all(AppSize.s20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LocatorSelector(),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppPadding.p6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.expectedTime,
                            style: getSemiLightStyle(
                                color: ColorManager.black,
                                fontSize: AppSize.s14),
                          ),
                          Obx(
                            () => Text(
                              expectedTime.value == 0
                                  ? AppStrings.chooseDestination
                                  : "${expectedTime.value} ${expectedTime.value == 1 ? AppStrings.expectedTimeUnit.substring(0, 6) : AppStrings.expectedTimeUnit}",
                              style: getSemiLightStyle(
                                  color: ColorManager.border,
                                  fontSize: AppSize.s12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppPadding.p6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.cost,
                            style: getSemiLightStyle(
                                color: ColorManager.black,
                                fontSize: AppSize.s14),
                          ),
                          Obx(
                            () => Text(
                              cost.value == 0
                                  ? AppStrings.chooseDestination
                                  : "${cost.value} ${AppStrings.costUnit}",
                              style: getSemiLightStyle(
                                  color: ColorManager.border,
                                  fontSize: AppSize.s12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: commentController,
                      style: getSemiLightStyle(
                          color: ColorManager.border, fontSize: AppSize.s14),
                      cursorColor: ColorManager.primary,
                      cursorWidth: AppSize.s1,
                      maxLines: 1,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorManager.border)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorManager.black)),
                        hintText: AppStrings.comment,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            button(
              text: AppStrings.yalla,
              context: context,
              onPressed: () {
                if (distance.value < 100) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: SizedBox(
                        height: 30,
                        child: Center(
                          child: Text(
                            "Choose Destination",
                          ),
                        ),
                      ),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
                else {
                  Get.toNamed(
                    Routes.driverSearchRoute,
                    arguments: [
                      Trip.request(
                        clientUsername: appClient.username,
                        pickupLocation: pickupLocation.value,
                        destinationLocation: destinationLocation.value,
                        polylineCode: polylineCode.value,
                        cost: cost.value,
                        distance: distance.value,
                        expectedTime: expectedTime.value,
                        comment: commentController.text,
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
