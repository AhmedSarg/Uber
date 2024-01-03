import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../resources/assets_manager.dart';
import '../../../resources/strings_manager.dart';

enum ThirdPartyType {facebook, twitter, google}

class ThirdPartyButton {
  final ThirdPartyType type;
  late String name;
  late String iconAsset;
  VoidCallback action = () {};

  ThirdPartyButton({required this.type}) {
    switch (type) {
      case ThirdPartyType.facebook:
        name = AppStrings.facebook;
        iconAsset = ImageAssets.facebookIcon;
        action = () {};
        break;
      case ThirdPartyType.twitter:
        name = AppStrings.twitter;
        iconAsset = ImageAssets.twitterIcon;
        action = () {};
        break;
      case ThirdPartyType.google:
        name = AppStrings.google;
        iconAsset = ImageAssets.googleIcon;
        action = () {};
        break;
    }
  }
}
