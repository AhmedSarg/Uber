import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber/presentation/resources/styles_manager.dart';
import 'package:uber/presentation/resources/values_manager.dart';

import 'color_manager.dart';
import 'font_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    // main colors
    primaryColor: ColorManager.dark,
    // primaryColorLight: ColorManager.lightPrimary,
    // primaryColorDark: ColorManager.darkPrimary,
    disabledColor: ColorManager.white,
    splashColor: ColorManager.lightBlack,
    // ripple effect color

    // cardview theme
    cardTheme: CardTheme(
        color: ColorManager.white,
        shadowColor: ColorManager.white,
        elevation: AppSize.s4),

    // app bar theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: ColorManager.dark,
      elevation: AppSize.s0,
      shadowColor: ColorManager.lightBlack,
      scrolledUnderElevation: 0,
      titleTextStyle:
          getRegularStyle(fontSize: FontSize.s16, color: ColorManager.white),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: ColorManager.dark,
        statusBarBrightness: Brightness.dark,
      ),
    ),

    // button theme
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      disabledColor: ColorManager.white,
      buttonColor: ColorManager.dark,
      splashColor: ColorManager.lightBlack,
    ),

    // TextButton theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: ColorManager.primary,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    ),

    // elevated button them
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(AppSize.s150, AppSize.s40),
        backgroundColor: ColorManager.white,
        foregroundColor: ColorManager.primary,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: ColorManager.border),
          borderRadius: BorderRadius.circular(AppSize.s16),
        ),
      ),
    ),

    // Text theme
    textTheme: TextTheme(
      displayLarge:
          getHeaderStyle(color: ColorManager.white, fontSize: FontSize.s30),
      displayMedium:
          getHeaderStyle(color: ColorManager.white, fontSize: FontSize.s20),
      displaySmall:
          getHeaderStyle(color: ColorManager.white, fontSize: FontSize.s10),
      headlineLarge:
          getSemiBoldStyle(color: ColorManager.white, fontSize: FontSize.s26),
      headlineMedium:
          getRegularStyle(color: ColorManager.white, fontSize: FontSize.s20),
      headlineSmall:
          getRegularStyle(color: ColorManager.white, fontSize: FontSize.s16),
      titleMedium:
          getMediumStyle(color: ColorManager.dark, fontSize: FontSize.s16),
      bodyLarge: getRegularStyle(color: ColorManager.white),
      bodySmall:
          getRegularStyle(color: ColorManager.white, fontSize: FontSize.s14),
      labelSmall: getRegularStyle(color: ColorManager.grey, fontSize: FontSize.s14),
    ),

    // input decoration theme (text form field)
    inputDecorationTheme: InputDecorationTheme(
        //color
        fillColor: ColorManager.white,
        filled: true,
        // content padding
        contentPadding: const EdgeInsets.all(AppPadding.p8),
        // hint style
        hintStyle: getRegularStyle(
            color: ColorManager.lightBlack, fontSize: FontSize.s14),
        labelStyle:
            getMediumStyle(color: ColorManager.white, fontSize: FontSize.s14),
        errorStyle: getRegularStyle(color: ColorManager.error),
        // enabled border style
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.dark, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8))),

        // focused border style
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.border, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8))),

        // error border style
        errorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.error, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8))),
        // focused border style
        focusedErrorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.dark, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)))),
    // label style


    snackBarTheme: SnackBarThemeData(
      backgroundColor: ColorManager.primary,
      behavior: SnackBarBehavior.fixed,
      contentTextStyle: getRegularStyle(color: ColorManager.white, fontSize: FontSize.s20),
    )
  );
}
