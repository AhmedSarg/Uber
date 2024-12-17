import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uber/data/global/variables.dart';
import 'package:uber/presentation/resources/routes_manager.dart';
import 'package:uber/presentation/resources/widgets.dart';
import 'package:uber/presentation/selection/model/selection_model.dart';
import 'package:uber/presentation/user_authentication/login/model/login_controller.dart';
import 'package:uber/presentation/user_authentication/login/model/login_model.dart';
import 'package:uber/presentation/user_authentication/model/user_authentication_model.dart'
    as auth;

import '../../../resources/assets_manager.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/strings_manager.dart';
import '../../../resources/values_manager.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
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
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: AppPadding.p60,
        ),
        child: Form(
          key: controller.formKey,
          child: ListView(
            physics: const RangeMaintainingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p40, vertical: AppPadding.p20),
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: AppPadding.p50,
                  left: AppPadding.p50,
                  top: AppPadding.p60,
                  bottom: AppPadding.p32,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    ImageAssets.carLogo,
                  ),
                ),
              ),
              textField(
                context: context,
                authenticationType: auth.AuthenticationType.login,
                fieldData: auth.FieldData(auth.FieldType.email),
                // validate: controller.isValid,
                controller: controller.emailController,
                focusNode: controller.emailFocusNode,
                nextFocus: controller.passwordFocusNode,
              ),
              textField(
                context: context,
                authenticationType: auth.AuthenticationType.login,
                fieldData: auth.FieldData(auth.FieldType.password),
                // validate: controller.isValid,
                controller: controller.passwordController,
                focusNode: controller.passwordFocusNode,
                nextFocus: null,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: AppPadding.p16, left: AppPadding.p10),
                child: GestureDetector(
                  onTap: null,
                  child: Text(
                    AppStrings.forgetPassword,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  thirdPartyButton(
                    buttonData: ThirdPartyButton(type: ThirdPartyType.facebook),
                    onTap: () {
                      controller.signInWithFacebook();
                      auth.selected.value = auth.Selected.t;
                      Get.toNamed(Routes.registerRoute);
                    },
                  ),
                  thirdPartyButton(
                    buttonData: ThirdPartyButton(type: ThirdPartyType.twitter),
                    onTap: () {
                      controller.signInWithTwitter();
                      auth.selected.value = auth.Selected.t;
                      Get.toNamed(Routes.registerRoute);
                    },
                  ),
                  thirdPartyButton(
                    buttonData: ThirdPartyButton(type: ThirdPartyType.google),
                    onTap: () {
                      controller.signInWithGoogle();
                      auth.selected.value = auth.Selected.t;
                      Get.toNamed(Routes.registerRoute);
                    },
                  ),
                ],
              ),
              userType == Selection.user
                  ? TextButton(
                      onPressed: () {
                        auth.selected.value = auth.Selected.f;
                        Get.toNamed(Routes.registerRoute);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: ColorManager.dark,
                        foregroundColor: ColorManager.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: ColorManager.border),
                          borderRadius: BorderRadius.circular(AppSize.s16),
                        ),
                      ),
                      child: Text(
                        AppStrings.registerButton,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
      bottomSheet: button(
        text: AppStrings.login,
        context: context,
        onPressed: () async {
          controller.emailFocusNode.unfocus();
          controller.passwordFocusNode.unfocus();
          if (controller.formKey.currentState!.validate()) {
            bool isSignedIn = await controller.signInWithEmailAndPassword();
            print(isSignedIn);
            if (isSignedIn) {
              snackbar(context, "Success Ya Basha");
              var email = controller.emailController.text.split('@');
              if (userType == Selection.user) {
                appClient = AppClient.setData(
                    username: email[0],
                    authenticationType: auth.AuthenticationType.login);
              } else {
                appDriver = AppDriver.setData(username: email[0]);
              }
              Get.offAllNamed(
                userType == Selection.user
                    ? Routes.clientMapRoute
                    : Routes.driverMapRoute,
              );
            } else {
              snackbar(
                context,
                "email or password is invalid",
                ColorManager.error,
              );
            }
          } else {
            snackbar(
              context,
              "ekteb 7aga Ya M3alem",
              ColorManager.error,
            );
          }
        },
      ),
    );
  }

  void snackbar(BuildContext context, String mass, [Color? background]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.zero,
        content: Container(
          height: AppSize.s60,
          color: background ?? ColorManager.primary,
          child: Center(
            child: FittedBox(
              child: Text(
                mass,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
        ),
        backgroundColor: ColorManager.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
