import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../model/user_authentication_model.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final _status = Rx<RxStatus>(RxStatus.empty());

  RxStatus get status => _status.value;
  FirebaseAuth auth = FirebaseAuth.instance;

  late String verificationId;
  // bool validateCode = true;

  final usernameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final dayController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();

  // otp code
  final otpTextField = TextEditingController();
  Gender gender = Gender.male;

  final usernameFocusNode = FocusNode();
  final fullNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final dayFocusNode = FocusNode();
  final monthFocusNode = FocusNode();
  final yearFocusNode = FocusNode();

  @override
  void onInit() {
    // signUpWithPhoneNumber();
    super.onInit();
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    print('closed');
    usernameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    dayFocusNode.dispose();
    monthFocusNode.dispose();
    yearFocusNode.dispose();
    super.onClose();
  }

  Future<void> signUpWithPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2${phoneNumberController.text}',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String id, int? resendToken) async {
        verificationId = id;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  sentCode() async {
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otpTextField.text);
      // Sign the user in (or link) with the credential
      await auth.signInWithCredential(credential);
      // print(1);
      print(credential.smsCode);
      return true;
    } catch (ex) {
      return false;
    }
  }

  signupWithEmailAndPassword() async {
    try {
      print(emailController.text);
      print(passwordController.text);
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
