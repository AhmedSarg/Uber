import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber/data/global/variables.dart';
import 'package:uber/data/models/trip_model.dart';
import 'package:uber/presentation/resources/color_manager.dart';
import 'package:uber/presentation/resources/routes_manager.dart';
import 'package:uber/presentation/resources/strings_manager.dart';
import 'package:uber/presentation/resources/styles_manager.dart';
import 'package:uber/presentation/resources/values_manager.dart';
import 'package:uber/presentation/resources/widgets.dart';
import 'package:uber/presentation/selection/model/selection_model.dart';

class RecieptView extends StatelessWidget {
  const RecieptView({super.key, required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: ColorManager.dark,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p20, vertical: AppPadding.p40),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              recieptRow(AppStrings.driverUsername, trip.driverUsername!),
              recieptRow(AppStrings.clientUsername, trip.clientUsername),
              recieptRow(AppStrings.expectedTime,
                  "${trip.expectedTime} ${AppStrings.expectedTimeUnit}"),
              recieptRow(AppStrings.startTime,
                  trip.startTime.toString().substring(11, 19)),
              recieptRow(
                  AppStrings.endTime, trip.endTime.toString().substring(11, 19)),
              recieptRow(AppStrings.actualTime,
                  "${trip.duration!.inMinutes} ${AppStrings.expectedTimeUnit}"),
              recieptRow(AppStrings.distance, trip.distance.toString()),
              Divider(),
              Container(
                margin: const EdgeInsets.symmetric(vertical: AppPadding.p10),
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorManager.white, width: AppSize.s1),
                  borderRadius: const BorderRadius.all(Radius.circular(AppSize.s18)),
                ),
                child: recieptRow(
                  AppStrings.cost,
                  trip.cost.toString(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: button(
        text: AppStrings.done,
        context: context,
        onPressed: () async {
          if (userType == Selection.driver) {
            var sourceDocument = await firestore.collection("availableTrips").doc(trip.tripId).get();
            await firestore.collection("reciepts").doc(trip.tripId).set(sourceDocument.data()!);
            await firestore.collection("availableTrips").doc(trip.tripId).delete();
            Get.offAllNamed(Routes.driverMapRoute);
          }
          else {
            Get.offAllNamed(Routes.feedbackRoute);
          }
        },
      ),
    );
  }

  Padding recieptRow(key, value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            key,
            style: getRegularStyle(
              color: ColorManager.white,
              fontSize: AppSize.s18,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Expanded(
            child: Text(
              value,
              style: getRegularStyle(
                color: ColorManager.white,
                fontSize: AppSize.s18,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
