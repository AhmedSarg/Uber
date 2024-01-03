import 'package:get/get.dart';

import '../../model/user_authentication_model.dart';

var genderEmpty = true.obs;
var genderError = false.obs;
Rx<Gender> genderValue = Gender.male.obs;