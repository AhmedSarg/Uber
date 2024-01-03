import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';
import '../model/selection_model.dart';

Widget option({
  required Selection value,
  required IconData icon,
  required String text,
  required BuildContext context,
  required Selection select,
}) {
  final double width = MediaQuery.of(context).size.width;
  return GestureDetector(
    onTap: () {
      selection.value = value;
    },
    child: Container(
      height: AppSize.s200,
      width: width * 0.35,
      padding: const EdgeInsets.all(AppPadding.p8),
      decoration: BoxDecoration(
        color: colorSelect(selection: selection.value, value: value, color: 1),
        borderRadius: BorderRadius.circular(AppSize.s16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: AppSize.s110,
            color: colorSelect(selection: select, value: value, color: 2),
          ),
          Text(
            text,
            style: TextStyle(
              color: colorSelect(selection: select, value: value, color: 2),
              fontFamily: FontConstants.cascadia,
              fontSize: FontSize.s28,
              fontWeight: FontWeightManager.semiBold,
            ),
          ),
        ],
      ),
    ),
  );
}

Color colorSelect(
    {required Selection selection, required Selection value, required int color}) {
  if (color == 1) {
    return (selection == value ? ColorManager.primary : ColorManager.white);
  } else if (color == 2) {
    return (selection == value ? ColorManager.white : ColorManager.black);
  } else {
    return ColorManager.white;
  }
}
