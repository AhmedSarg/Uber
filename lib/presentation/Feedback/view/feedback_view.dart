import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uber/presentation/resources/assets_manager.dart';
import 'package:uber/presentation/resources/constants_manager.dart';

import 'package:rate/rate.dart' as rate;
import 'package:uber/presentation/resources/routes_manager.dart';
import 'package:uber/presentation/resources/widgets.dart';
import '../../resources/color_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';
import '../model/feedback_controller.dart';

class FeedbackView extends GetView<FeedbackController> {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FeedbackController());
    final double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorManager.dark,
      appBar: AppBar(
        title: Text(
          AppStrings.feedback,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p20,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppPadding.p12),
                  child: CircleAvatar(
                    radius: AppSize.s36,
                    backgroundColor: ColorManager.primary,
                    child: CircleAvatar(
                      backgroundColor: ColorManager.dark,
                      radius: AppSize.s32,
                      child: SvgPicture.asset(
                        ImageAssets.driverIcon,
                        color: ColorManager.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: w - AppSize.s136,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(AppPadding.p8),
                        child: Expanded(
                          child: Text(
                            'Cpt.Sherif Mohamed',
                            style: Theme.of(context).textTheme.headlineMedium,
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: AppPadding.p8),
                        child: rate.Rate(
                          initialValue: 3.5,
                          color: Colors.amber,
                          allowHalf: true,
                          readOnly: true,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppPadding.p30),
              child: rate.Rate(
                initialValue: AppConstants.initialRating,
                color: Colors.amber,
                allowHalf: true,
                onChange: (rate) {
                  print(rate);
                },
                iconSize: AppSize.s40,
                readOnly: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppPadding.p16),
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  AppStrings.comment,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            TextFormField(
              controller: controller.feedbackController,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              maxLines: AppConstants.maxLines,
              maxLength: AppConstants.maxLength,
              decoration: const InputDecoration(
                hintText: 'Enter your feedback here',
              ),
            ),
          ],
        ),
      ),
      bottomSheet: button(
        text: AppStrings.done,
        context: context,
        onPressed: () {
          Get.offAllNamed(Routes.clientMapRoute);
        },
      ),
    );
  }
}
