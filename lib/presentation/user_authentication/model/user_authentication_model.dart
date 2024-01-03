import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../resources/strings_manager.dart';

enum AuthenticationType { login, register }

enum FieldType { email, password, phoneNumber, username, confirmPassword, fullName }

enum DateType { day, month, year }

enum Gender { male, female }

enum Selected {t, f}
var selected = Selected.f.obs;

class FieldData {
  String text = "";
  String hint = "";

  var obscure = false.obs;
  var isPasswordField = false.obs;

  TextInputType keyboardType = TextInputType.text;
  Function validate =
      (TextEditingController controller, TextEditingController? password) {
    if (controller.value.text.isEmpty) {
      return AppStrings.fieldRequired;
    }
    return null;
  };

  FieldData(FieldType fieldType) {
    switch (fieldType) {
      case FieldType.email:
        text = AppStrings.email;
        hint = AppStrings.emailExample;
        keyboardType = TextInputType.emailAddress;
        obscure.value = false;
        validate = (TextEditingController controller,
            TextEditingController? password) {
          if (controller.value.text.isEmpty) {
            return AppStrings.fieldRequired;
          } else if (!controller.value.text.isEmail) {
            return AppStrings.emailError;
          }
          return null;
        };
        break;
      case FieldType.username:
        text = AppStrings.username;
        hint = AppStrings.usernameExample;
        keyboardType = TextInputType.name;
        obscure.value = false;
        validate = (TextEditingController controller,
            TextEditingController? password) {
          if (controller.value.text.isEmpty) {
            return AppStrings.fieldRequired;
          } else if (!RegExp(r'^[a-zA-Z0-9]+$')
              .hasMatch(controller.value.text)) {
            return AppStrings.usernameError;
          }
          return null;
        };
        break;
      case FieldType.fullName:
        text = AppStrings.fullname;
        hint = AppStrings.fullnameExample;
        keyboardType = TextInputType.text;
        obscure.value = false;
        validate = (TextEditingController controller,
            TextEditingController? password) {
          if (controller.value.text.isEmpty) {
            return AppStrings.fieldRequired;
          }
          return null;
        };
        break;
      case FieldType.password:
        text = AppStrings.password;
        hint = AppStrings.passwordExample;
        keyboardType = TextInputType.visiblePassword;
        obscure.value = true;
        isPasswordField.value = true;
        validate = (TextEditingController controller,
            TextEditingController? password) {
          return valid(controller,password,0);
        };
        break;
      case FieldType.confirmPassword:
        text = AppStrings.confirmPassword;
        hint = AppStrings.passwordExample;
        keyboardType = TextInputType.visiblePassword;
        obscure.value = true;
        isPasswordField.value = true;
        validate = (TextEditingController controller,
            TextEditingController? password) {
          return valid(controller,password,1);
        };
        break;
      case FieldType.phoneNumber:
        text = AppStrings.phoneNumber;
        hint = AppStrings.phoneNumberExample;
        keyboardType = TextInputType.phone;
        obscure.value = false;
        validate = (TextEditingController controller,
            TextEditingController? password) {
          if (controller.value.text.isEmpty) {
            return AppStrings.fieldRequired;
          } else if (controller.value.text.length != 11 ||
              !(controller.value.text[0] == '0' &&
                  controller.value.text[1] == '1')) {
            return AppStrings.phoneNumberError;
          }
          return null;
        };
        break;
    }
  }

  String? valid(TextEditingController controller,password,int pass) {
    List<RegExp> regex =
    [RegExp(r'^(.*[A-Z].*)$'),
    RegExp(r'^(.*[a-z].*)$'),
    RegExp(r'^(.*?[0-9].*)$'),
    RegExp(r'^(.*?[!@#\$&*~].*)$'),
    RegExp(r'^.{8,}$')];
    if (controller.value.text.isEmpty) {
      return AppStrings.fieldRequired;
    } else if (pass == 1 && controller.value.text != password.value.text) {
      print(0);
      return AppStrings.matchError;
    } else if (!regex[0].hasMatch(controller.value.text)) {
      print(controller.value.text);
      return AppStrings.upperCaseError;
    }else if (!regex[1].hasMatch(controller.value.text)) {
      print(2);
      return AppStrings.lowerCaseError;
    }else if (!regex[2].hasMatch(controller.value.text)) {
      print(3);
      return AppStrings.digitError;
    }else if (!regex[3].hasMatch(controller.value.text)) {
      print(4);
      return AppStrings.specialCharacterError;
    }else if (!regex[4].hasMatch(controller.value.text)) {
      print(5);
      return AppStrings.lengthError;
    }
    return null;
  }
}

class DateData {
  String text = "";
  int length = 0;
  int max = 0;
  int min = 0;
  BorderRadius roundedSide = BorderRadius.zero;

  DateData(DateType dateType) {
    switch (dateType) {
      case DateType.day:
        text = "Day";
        length = 2;
        max = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
        min = 1;
        roundedSide = const BorderRadius.horizontal(left: Radius.circular(10));
        break;
      case DateType.month:
        text = "Month";
        length = 2;
        max = 12;
        min = 1;
        roundedSide = BorderRadius.zero;
        break;
      case DateType.year:
        text = "Year";
        length = 4;
        max = DateTime.now().year;
        min = 1910;
        roundedSide = const BorderRadius.horizontal(right: Radius.circular(10));
        break;
    }
  }
}
