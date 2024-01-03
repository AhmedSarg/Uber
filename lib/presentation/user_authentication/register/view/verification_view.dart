import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:uber/data/global/variables.dart';
import 'package:uber/presentation/resources/color_manager.dart';
import 'package:uber/presentation/resources/routes_manager.dart';
import 'package:uber/presentation/resources/strings_manager.dart';
import 'package:uber/presentation/resources/widgets.dart';
import 'package:uber/presentation/user_authentication/model/user_authentication_model.dart';
import 'package:uber/presentation/user_authentication/register/model/register_model.dart';

import '../model/register_controller.dart';

class VerificationView extends GetView<RegisterController> {
  const VerificationView({super.key});

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
                // controller.onClose();
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
      body: Center(
        child: OtpTextField(
          numberOfFields: 6,
          showFieldAsBox: true,
          borderWidth: 2.0,
          fillColor: ColorManager.white,
          filled: true,
          //runs when every textfield is filled
          onSubmit: (String verificationCode) {
            controller.otpTextField.text = verificationCode;
          },
        ),
      ),
      bottomSheet: button(
        text: AppStrings.confirm,
        context: context,
        onPressed: () async {
          if (controller.otpTextField.text.length == 6) {
            if (await controller.sentCode()) {
              controller.signupWithEmailAndPassword();

              try {
                appClient = AppClient.setData(
                  username: controller.emailController.text.split('@')[0],
                  fullName: controller.fullNameController.text,
                  email: controller.emailController.text,
                  phoneNumber: controller.phoneNumberController.text,
                  gender: genderValue.value,
                  dateOfBirth: "${controller.yearController.text}-${controller.monthController.text}-${controller.dayController.text}",
                  authenticationType: AuthenticationType.register,
                );
              } catch (e) {
                print(e);
              }


              snackbar(context, "5osh Ya Basha");
              Get.offAllNamed(Routes.clientMapRoute);
            } else {
              snackbar(context, "Try Again Ya M3alem");
            }
          } else {
            snackbar(context, "Fadya Ya M3alem");
          }
        },
      ),
    );
  }

  void snackbar(BuildContext context, String mass) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SizedBox(
          height: 30,
          child: Center(
            child: Text(
              mass,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        backgroundColor: ColorManager.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
