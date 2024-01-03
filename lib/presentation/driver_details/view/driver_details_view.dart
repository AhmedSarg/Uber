import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/data/models/trip_model.dart';
import 'package:uber/presentation/driver_details/viewmodel/driver_details_cubit/driver_details_cubit.dart';
import 'package:uber/presentation/driver_details/viewmodel/driver_details_cubit/driver_details_state.dart';
import 'package:uber/presentation/resources/assets_manager.dart';
import 'package:uber/presentation/resources/color_manager.dart';
import 'package:uber/presentation/resources/strings_manager.dart';
import 'package:uber/presentation/resources/styles_manager.dart';
import 'package:uber/presentation/resources/values_manager.dart';
import 'package:uber/presentation/resources/widgets.dart';

class DriverDetailsView extends StatelessWidget {
  const DriverDetailsView({super.key, required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    print("screen rebuilt");
    var viewModel = BlocProvider.of<DriverDetailsCubit>(context);
    viewModel.init(context, trip);
    // viewModel.getMarkerIcons(context);
    // print(1);
    // viewModel.trip = trip;
    // viewModel.getUserLocation();
    // print(2);
    // viewModel.getDriverDetails();
    // print(3);
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height / 3;
    return BlocBuilder<DriverDetailsCubit, DriverDetailsState>(
      builder: (context, state) {
        print("bloc rebuilt");
        print(state.runtimeType);
        if (state is DriverDetailsLoadingState) {
          return Scaffold(
            backgroundColor: ColorManager.white,
            body: Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
                color: ColorManager.primary,
              ),
            ),
          );
        } else if (state is DriverDetailsSuccessState) {
          print(4);
          return Scaffold(
            backgroundColor: ColorManager.white,
            body: SafeArea(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.only(bottom: AppSize.s62 + h),
                    child: GoogleMap(
                      onMapCreated: (controller) {
                        print(5);
                        viewModel.mapOnSuccess(controller);
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          viewModel.userLocation.latitude,
                          viewModel.userLocation.longitude,
                        ),
                        zoom: AppSize.s18,
                      ),
                      markers: viewModel.markers.toSet(),
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
                            viewModel.mapController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: LatLng(
                                    viewModel.userLocation.latitude,
                                    viewModel.userLocation.longitude,
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
              ),
            ),
            bottomSheet: Container(
              width: w,
              height: AppSize.s62 + h,
              decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSize.s20),
                  ),
                  border: Border.all(
                      color: ColorManager.border, width: AppSize.s1)),
              child: Column(
                children: [
                  Container(
                    height: h,
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                    child: SingleChildScrollView(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppPadding.p10),
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
                                      viewModel.driver!.fullName,
                                      style: getRegularStyle(
                                        color: ColorManager.primary,
                                        fontSize: AppSize.s18,
                                      ),
                                    ),
                                    Text(
                                      "@${viewModel.driver!.username}",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: AppSize.s40,
                                  height: AppSize.s40,
                                  child: Icon(
                                    Icons.phone,
                                    color: ColorManager.dark,
                                    size: AppSize.s40,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    viewModel.callDriver();
                                  },
                                  child: Text(
                                    viewModel.driver!.phoneNumber,
                                    style: getSemiLightStyle(
                                      color: ColorManager.primary,
                                      fontSize: AppSize.s18,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: AppSize.s40,
                                  height: AppSize.s40,
                                  child: SvgPicture.asset(ImageAssets.carInfo),
                                ),
                                Text(
                                  viewModel.driver!.carModel,
                                  style: getSemiLightStyle(
                                    color: ColorManager.dark,
                                    fontSize: AppSize.s18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppPadding.p6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: AppSize.s40,
                                  height: AppSize.s40,
                                  child: SvgPicture.asset(ImageAssets.fillDrip),
                                ),
                                Text(
                                  viewModel.driver!.carColor,
                                  style: getSemiLightStyle(
                                    color: ColorManager.dark,
                                    fontSize: AppSize.s18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppPadding.p6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: AppSize.s40,
                                  height: AppSize.s40,
                                  child: SvgPicture.asset(ImageAssets.license),
                                ),
                                Text(
                                  viewModel.driver!.carLicense,
                                  style: getSemiLightStyle(
                                    color: ColorManager.dark,
                                    fontSize: AppSize.s18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  button(
                    text: AppStrings.share,
                    context: context,
                    onPressed: () {
                      viewModel.shareTrip();
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: ColorManager.white,
            body: Container(
              color: ColorManager.white.withOpacity(0.6),
              width: double.infinity,
              height: double.infinity,
              margin: EdgeInsets.only(bottom: h + AppSize.s62),
              child: const Center(
                child: Text("Error"),
              ),
            ),
          );
        }
      },
    );
  }
}
