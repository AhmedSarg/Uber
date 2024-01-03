import 'package:flutter/material.dart';
import 'package:uber/presentation/resources/color_manager.dart';

import 'font_manager.dart';

TextStyle _getTextStyle(String fontFamily, double fontSize, FontWeight fontWeight, Color color) {
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
  );
}

// regular style

TextStyle getRegularStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(FontConstants.cascadia, fontSize, FontWeightManager.regular, color);
}

// medium style

TextStyle getMediumStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(FontConstants.cascadia, fontSize, FontWeightManager.semiBold, color);
}

// Light style

TextStyle getLightStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(FontConstants.cascadia, fontSize, FontWeightManager.light, color);
}

TextStyle getSemiLightStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(FontConstants.cascadia, fontSize, FontWeightManager.semiLight, color);
}

// bold style

TextStyle getBoldStyle({double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(FontConstants.cascadia, fontSize, FontWeightManager.bold, color);
}

// semiBold style

TextStyle getSemiBoldStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(FontConstants.cascadia, fontSize, FontWeightManager.semiBold, color);
}

TextStyle getHeaderStyle(
    {double fontSize = FontSize.s30, required Color color}) {
  return _getTextStyle(FontConstants.verdana, fontSize, FontWeightManager.semiBold, color);
}

TextStyle getErrorStyle() {
  return _getTextStyle(FontConstants.cascadia, FontSize.s12, FontWeightManager.semiBold, ColorManager.error);
}