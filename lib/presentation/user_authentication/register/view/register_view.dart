import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber/presentation/resources/routes_manager.dart';
import 'package:uber/presentation/resources/values_manager.dart';
import 'package:uber/presentation/resources/widgets.dart';
import 'package:uber/presentation/user_authentication/model/user_authentication_model.dart'
    as auth;
import 'package:uber/presentation/user_authentication/register/model/register_controller.dart';

import '../../../resources/color_manager.dart';
import '../../../resources/strings_manager.dart';
import '../model/register_model.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RegisterController());
    return Scaffold(
      backgroundColor: ColorManager.dark,
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        automaticallyImplyLeading: false,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Ink(
            width: 40,
            height: 40,
            decoration: ShapeDecoration(
              color: ColorManager.darkGrey,
              shape: const CircleBorder(),
            ),
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              splashRadius: 20,
              padding: const EdgeInsets.only(right: 2),
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: ColorManager.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: AppPadding.p40),
        child: Form(
          key: controller.formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              right: AppPadding.p40,
              left: AppPadding.p40,
              bottom: AppPadding.p40,
            ),
            children: [
              // (auth.selected.value == auth.Selected.f)
              //     ? textField(
              //         context: context,
              //         authenticationType: auth.AuthenticationType.register,
              //         fieldData: auth.FieldData(auth.FieldType.username),
              //         controller: controller.usernameController,
              //         focusNode: controller.usernameFocusNode,
              //         nextFocus: controller.fullNameFocusNode,
              //       )
              //     : const SizedBox(),
              textField(
                context: context,
                authenticationType: auth.AuthenticationType.register,
                fieldData: auth.FieldData(auth.FieldType.fullName),
                controller: controller.fullNameController,
                focusNode: controller.fullNameFocusNode,
                nextFocus: controller.emailFocusNode,
              ),
              textField(
                context: context,
                authenticationType: auth.AuthenticationType.register,
                fieldData: auth.FieldData(auth.FieldType.email),
                controller: controller.emailController,
                focusNode: controller.emailFocusNode,
                nextFocus: controller.passwordFocusNode,
              ),
              (auth.selected.value == auth.Selected.f)
                  ? textField(
                      context: context,
                      authenticationType: auth.AuthenticationType.register,
                      fieldData: auth.FieldData(auth.FieldType.password),
                      controller: controller.passwordController,
                      focusNode: controller.passwordFocusNode,
                      nextFocus: controller.confirmPasswordFocusNode,
                    )
                  : const SizedBox(),
              (auth.selected.value == auth.Selected.f)
                  ? textField(
                      context: context,
                      authenticationType: auth.AuthenticationType.register,
                      fieldData: auth.FieldData(auth.FieldType.confirmPassword),
                      controller: controller.confirmPasswordController,
                      passwordConfirm: controller.passwordController,
                      focusNode: controller.confirmPasswordFocusNode,
                      nextFocus: controller.phoneNumberFocusNode,
                    )
                  : const SizedBox(),
              textField(
                context: context,
                authenticationType: auth.AuthenticationType.register,
                fieldData: auth.FieldData(auth.FieldType.phoneNumber),
                controller: controller.phoneNumberController,
                focusNode: controller.phoneNumberFocusNode,
                nextFocus: null,
              ),
              dateFields(context: context, controller: controller),
              genders(context: context),
            ],
          ),
        ),
      ),
      bottomSheet: button(
        text: AppStrings.register,
        context: context,
        onPressed: () {
          controller.emailFocusNode.unfocus();
          controller.phoneNumberFocusNode.unfocus();
          controller.dayFocusNode.unfocus();
          controller.monthFocusNode.unfocus();
          controller.yearFocusNode.unfocus();
          if (auth.selected.value == auth.Selected.f) {
            controller.usernameFocusNode.unfocus();
            controller.passwordFocusNode.unfocus();
            controller.confirmPasswordFocusNode.unfocus();
          }
          if (genderEmpty.value) {
            genderError.value = true;
          }
          if (controller.formKey.currentState!.validate() &&
              !genderEmpty.value) {
            controller.gender = genderValue.value;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: SizedBox(
                  height: 30,
                  child: Center(
                    child: Text(
                      "Success Ya Basha",
                    ),
                  ),
                ),
                duration: Duration(seconds: 1),
              ),
            );
            controller.signUpWithPhoneNumber();
            Get.toNamed(Routes.verificationRoute);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: SizedBox(
                  height: 30,
                  child: Center(
                    child: Text(
                      "Try Again Ya M3alem",
                    ),
                  ),
                ),
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
      ),
    );
  }
}
