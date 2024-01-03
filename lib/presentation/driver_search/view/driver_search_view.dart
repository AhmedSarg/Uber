import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uber/data/models/trip_model.dart';
import 'package:uber/presentation/driver_search/viewmodel/driver_search_viewmodel.dart';
import 'package:uber/presentation/resources/assets_manager.dart';
import 'package:uber/presentation/resources/color_manager.dart';
import 'package:uber/presentation/resources/strings_manager.dart';
import 'package:uber/presentation/resources/styles_manager.dart';
import 'package:uber/presentation/resources/values_manager.dart';
import 'package:uber/presentation/resources/widgets.dart';

class DriverSearchView extends StatefulWidget {
  const DriverSearchView({super.key, required this.trip});

  final Trip trip;

  @override
  State<DriverSearchView> createState() => _DriverSearchViewState();
}

class _DriverSearchViewState extends State<DriverSearchView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late DriverSearchViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = DriverSearchViewModel(trip: widget.trip);
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  Widget _buildBody() {
    return AnimatedBuilder(
      animation:
          CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(100 * _controller.value),
            _buildContainer(190 * _controller.value),
            _buildContainer(280 * _controller.value),
            _buildContainer(370 * _controller.value),
            Align(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: ColorManager.primary,
                child: Center(
                  child: SvgPicture.asset(
                    ImageAssets.userLocatorIcon,
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
            Border.all(color: ColorManager.primary.withOpacity(1 - _controller.value)),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (value) {
        widget.trip.cancelTrip();
      },
      child: Scaffold(
        backgroundColor: ColorManager.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 370,
                child: _buildBody(),
              ),
              const SizedBox(
                height: AppSize.s30,
              ),
              Text(
                AppStrings.driverSearch,
                style: getSemiBoldStyle(color: ColorManager.black),
              ),
            ],
          ),
        ),
        bottomSheet: button(
          text: AppStrings.cancel,
          context: context,
          onPressed: () {
            widget.trip.cancelTrip();
            Get.back();
          },
        ),
      ),
    );
  }
}
