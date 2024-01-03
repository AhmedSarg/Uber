import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/data/models/trip_model.dart';
import 'package:uber/presentation/client_details/viewmodel/client_details_cubit/client_details_cubit.dart';
import 'package:uber/presentation/client_details/viewmodel/client_details_cubit/client_details_state.dart';
import 'package:uber/presentation/resources/assets_manager.dart';
import 'package:uber/presentation/resources/color_manager.dart';
import 'package:uber/presentation/resources/routes_manager.dart';
import 'package:uber/presentation/resources/strings_manager.dart';
import 'package:uber/presentation/resources/styles_manager.dart';
import 'package:uber/presentation/resources/values_manager.dart';
import 'package:uber/presentation/resources/widgets.dart';

class ClientDetailsView extends StatelessWidget {
  const ClientDetailsView({super.key, required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    var viewModel = BlocProvider.of<ClientDetailsCubit>(context);
    viewModel.init(context, trip);
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height / 5;
    return BlocBuilder<ClientDetailsCubit, ClientDetailsState>(
      builder: (context, state) {
        print(state.runtimeType);
        if (state is ClientDetailsLoadingState) {
          return Scaffold(
            backgroundColor: ColorManager.white,
            body: Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
                color: ColorManager.primary,
              ),
            ),
          );
        } else if (state is ClientDetailsSuccessState) {
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
                    width: w,
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                    child: SingleChildScrollView(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppPadding.p14),
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
                                      viewModel.client!.fullName!,
                                      style: getRegularStyle(
                                        color: ColorManager.primary,
                                        fontSize: AppSize.s18,
                                      ),
                                    ),
                                    Text(
                                      "@${viewModel.client!.username}",
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
                                    viewModel.callClient();
                                  },
                                  child: Text(
                                    viewModel.client!.phoneNumber!,
                                    style: getSemiLightStyle(
                                      color: ColorManager.primary,
                                      fontSize: AppSize.s18,
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
                  Obx(
                    () => viewModel.started.value
                        ? button(
                          text: AppStrings.end,
                          context: context,
                          onPressed: () {
                            viewModel.endTrip();
                            Get.offAllNamed(Routes.recieptRoute, arguments: [viewModel.trip]);
                          },
                        )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: (w / 2) - 1.5,
                                child: button(
                                  text: AppStrings.cancel,
                                  context: context,
                                  onPressed: () {
                                    viewModel.cancelTrip();
                                    Get.offAllNamed(Routes.driverMapRoute);
                                    },
                                ),
                              ),
                              SizedBox(
                                width: (w / 2) - 1.5,
                                child: button(
                                  text: AppStrings.start,
                                  context: context,
                                  onPressed: () {
                                    viewModel.startTrip();
                                  },
                                ),
                              ),
                            ],
                          ),
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
