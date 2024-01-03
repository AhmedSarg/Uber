import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uber/data/global/variables.dart';
import 'package:uber/presentation/resources/assets_manager.dart';
import 'package:uber/presentation/resources/color_manager.dart';
import 'package:uber/presentation/resources/strings_manager.dart';

import '../../resources/routes_manager.dart';
import '../../resources/values_manager.dart';
import '../../resources/widgets.dart';
import '../model/selection_model.dart';
import '../viewmodel/selection_viewmodel.dart';

class SelectionView extends StatelessWidget {
  const SelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorManager.dark,
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppPadding.p80,
                horizontal: AppPadding.p90,
              ),
              child: Center(
                  child: SvgPicture.asset(
                ImageAssets.carLogo,
              )),
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  option(
                    value: Selection.user,
                    icon: Icons.person_outline_rounded,
                    text: AppStrings.user,
                    context: context,
                    select: selection.value,
                  ),
                  option(
                    value: Selection.driver,
                    icon: Icons.drive_eta_outlined,
                    text: AppStrings.driver,
                    context: context,
                    select: selection.value,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomSheet: button(
        context: context,
        text: AppStrings.next,
        onPressed: () {
          userType = selection.value;
          Get.toNamed(Routes.loginRoute);
          // Get.offAllNamed(userType == Selection.user ? Routes.clientMapRoute : Routes.driverMapRoute);
        },
      ),
    );
  }
}
