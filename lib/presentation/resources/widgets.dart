import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:uber/presentation/resources/font_manager.dart';
import 'package:uber/presentation/resources/styles_manager.dart';
import 'package:uber/presentation/user_authentication/login/model/login_model.dart';
import 'package:uber/presentation/user_authentication/model/user_authentication_model.dart';
import 'package:uber/presentation/resources/strings_manager.dart';
import 'package:uber/presentation/resources/values_manager.dart';
import 'package:uber/presentation/user_authentication/register/model/register_controller.dart';
import 'package:uber/presentation/user_authentication/register/model/register_model.dart';
import 'color_manager.dart';

Widget button({
  required String text,
  Function()? onPressed,
  required BuildContext context,
}) {
  return SizedBox(
    width: double.infinity,
    height: AppSize.s60,
    child: TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    ),
  );
}

Widget thirdPartyButton({required ThirdPartyButton buttonData, required Function() onTap}) {
  return Container(
    width: AppSize.s50,
    height: AppSize.s50,
    margin: const EdgeInsets.only(
      right: AppMargin.m8,
      left: AppMargin.m8,
      top: AppMargin.m40,
      bottom: AppMargin.m20,
    ),
    child: ElevatedButton(
      onPressed: onTap,
      child: SvgPicture.asset(
        buttonData.iconAsset,
        semanticsLabel: buttonData.name,
      ),
    ),
  );
}

Widget textField({
  required BuildContext context,
  required AuthenticationType authenticationType,
  required FieldData fieldData,
  required TextEditingController controller,
  TextEditingController? passwordConfirm,
  required FocusNode? focusNode,
  required FocusNode? nextFocus,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(
          bottom: AppPadding.p8,
          left: AppPadding.p8,
          top: AppPadding.p20,
        ),
        child: Text(
          fieldData.text,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      Obx(
        () => TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: (value) {
            return authenticationType == AuthenticationType.login
                ? (controller.value.text.isEmpty
                    ? AppStrings.fieldRequired
                    : null)
                : fieldData.validate(controller, passwordConfirm);
          },
          onFieldSubmitted: (_) {
            nextFocus?.requestFocus();
          },
          textInputAction:
              nextFocus == null ? TextInputAction.done : TextInputAction.next,
          keyboardType: fieldData.keyboardType,
          obscureText: fieldData.obscure.value,
          obscuringCharacter: '*',
          cursorColor: ColorManager.primary,
          style: getMediumStyle(color: ColorManager.black, fontSize: AppSize.s14),
          decoration: InputDecoration(
            hintText: fieldData.hint,
            errorMaxLines: AppSize.s60.toInt(),
            suffixIcon: fieldData.isPasswordField.value
                ? IconButton(
                    onPressed: () {
                      fieldData.obscure.toggle();
                    },
                    color: ColorManager.black,
                    padding: EdgeInsets.zero,
                    iconSize: AppSize.s18,
                    icon: SizedBox(
                      width: AppSize.s24,
                      child: Icon(
                        fieldData.obscure.value
                            ? FontAwesomeIcons.eyeSlash
                            : FontAwesomeIcons.eye,
                        // size: AppSize.s18,
                        color: ColorManager.black,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    ],
  );
}

Widget dateFields({
  required BuildContext context,
  required RegisterController controller,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(
          bottom: AppPadding.p8,
          left: AppPadding.p8,
          top: AppPadding.p20,
        ),
        child: Text(
          AppStrings.dateOfBirth,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      Row(
        children: [
          dateField(
            context: context,
            dateData: DateData(DateType.day),
            controller1: controller.dayController,
            controller2: controller.monthController,
            controller3: controller.yearController,
            focusNode: controller.dayFocusNode,
            nextFocus: controller.monthFocusNode,
          ),
          dateField(
            context: context,
            dateData: DateData(DateType.month),
            controller1: controller.monthController,
            controller2: controller.dayController,
            controller3: controller.yearController,
            focusNode: controller.monthFocusNode,
            nextFocus: controller.yearFocusNode,
          ),
          dateField(
            context: context,
            dateData: DateData(DateType.year),
            controller1: controller.yearController,
            controller2: controller.dayController,
            controller3: controller.monthController,
            focusNode: controller.yearFocusNode,
            nextFocus: null,
          ),
        ],
      ),
    ],
  );
}

Widget dateField({
  required BuildContext context,
  required DateData dateData,
  required TextEditingController controller1,
  required TextEditingController controller2,
  required TextEditingController controller3,
  required FocusNode? focusNode,
  required FocusNode? nextFocus,
}) {
  final double width = MediaQuery.of(context).size.width;
  return SizedBox(
    width: (width - AppPadding.p40 * 2) / 3,
    child: TextFormField(
      controller: controller1,
      validator: (value) {
        if (value!.isEmpty) {
          return AppStrings.fieldRequired;
        }
        if (controller2.text.isEmpty || controller3.text.isEmpty) {
          return "\n";
        }
        return null;
      },
      onFieldSubmitted: (value) {
        if (controller1.text.length < dateData.length) {
          controller1.text = controller1.text.padLeft(dateData.length, '0');
        }
        nextFocus?.requestFocus();
      },
      onChanged: (value) {
        if (!value[value.length - 1].isNumericOnly) {
          controller1.text = controller1.text.substring(0, value.length - 1);
          controller1.selection =
              TextSelection.collapsed(offset: value.length - 1);
        }
        if (int.parse(value) > dateData.max) {
          controller1.text = dateData.max.toString();
          controller1.selection =
              TextSelection.collapsed(offset: dateData.max.toString().length);
        } else if (int.parse(value) < 1) {
          controller1.text = dateData.min.toString();
          controller1.selection =
              TextSelection.collapsed(offset: dateData.min.toString().length);
        }
      },
      textAlign: TextAlign.center,
      maxLength: dateData.length,
      keyboardType: TextInputType.number,
      textInputAction:
          nextFocus == null ? TextInputAction.done : TextInputAction.next,
      focusNode: focusNode,
      style: getMediumStyle(color: ColorManager.black, fontSize: AppSize.s14),
      decoration: InputDecoration(
        hintText: dateData.text,
        errorMaxLines: AppSize.s60.toInt(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorManager.border,
          ),
          borderRadius: dateData.roundedSide,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorManager.border,
          ),
          borderRadius: dateData.roundedSide,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorManager.error, width: 1.5),
          borderRadius: dateData.roundedSide,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorManager.error, width: 1.5),
          borderRadius: dateData.roundedSide,
        ),
        counterText: "",
      ),
    ),
  );
}

Widget genders({
  required BuildContext context,
}) {
  final width = MediaQuery.of(context).size.width;
  return Obx(
    () => Container(
      width: width - AppPadding.p40 * 2,
      margin: const EdgeInsets.only(
        top: AppMargin.m20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: AppPadding.p8,
              left: AppPadding.p8,
            ),
            child: Text(
              AppStrings.gender,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Row(
            children: [
              gender(context: context, gender: Gender.male),
              gender(context: context, gender: Gender.female),
            ],
          ),
          genderError.value
              ? Padding(
                  padding: const EdgeInsets.only(
                      top: AppPadding.p8, left: AppPadding.p8),
                  child: Text(
                    AppStrings.fieldRequired,
                    style: getErrorStyle(),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    ),
  );
}

Widget gender({
  required BuildContext context,
  required Gender gender,
}) {
  final width = MediaQuery.of(context).size.width;
  return TextButton(
    onPressed: () {
      genderEmpty.value = false;
      genderError.value = false;
      genderValue.value = gender;
    },
    style: TextButton.styleFrom(
        fixedSize: Size((width - AppPadding.p40 * 2) / 2, 50),
        backgroundColor: genderEmpty.value
            ? ColorManager.white
            : (gender == genderValue.value
                ? ColorManager.primary
                : ColorManager.white),
        foregroundColor: genderEmpty.value
            ? ColorManager.grey
            : (gender == genderValue.value
                ? ColorManager.white
                : ColorManager.grey),
        shape: RoundedRectangleBorder(
          borderRadius: gender == Gender.male
              ? const BorderRadius.horizontal(
                  left: Radius.circular(10),
                )
              : const BorderRadius.horizontal(
                  right: Radius.circular(10),
                ),
        ),
        side: BorderSide(
            color:
                genderError.value ? ColorManager.error : ColorManager.border)),
    child: Text(
      gender == Gender.male ? AppStrings.genderMale : AppStrings.genderFemale,
      style: const TextStyle(
        fontFamily: FontConstants.cascadia,
      ),
    ),
  );
}
