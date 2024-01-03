import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final _status = Rx<RxStatus>(RxStatus.empty());
  FirebaseAuth auth = FirebaseAuth.instance;

  RxStatus get status => _status.value;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  // bool isValid(TextEditingController value) {
  //   if (value.value.text.isNotEmpty) return true;
  //   return false;
  // }

  Future<void> signInWithFacebook() async {
    print(1);
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    print(googleUser!.displayName);
    print(googleUser.email);
    print(googleUser.id);
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signInWithTwitter() async {
    // Create a TwitterLogin instance
    final twitterLogin = TwitterLogin(
        apiKey: 'QHdVcI4CAznyj2FvwZ1rmM3n2',
        apiSecretKey: 'MWguBIIYTZgiULjv1gPhOFeIO1Zjj3vZzImFhTm5ptQsnnfWDy',
        redirectURI: 'flutter-twitter-login://');
    // Trigger the sign-in flow
    final authResult = await twitterLogin.login();
    // Create a credential from the access token
    final twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: authResult.authToken!,
      secret: authResult.authTokenSecret!,
    );
    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
  }

  Future<bool> signInWithEmailAndPassword() async {
    try {
      print(emailController.text);
      print(passwordController.text);
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      print(userCredential.credential);
      print(userCredential.user);
      print(userCredential.additionalUserInfo);
      return true;
    } on FirebaseAuthException catch (e) {
        print('xx');
        print(e);
      if (e.code == 'invalid-email') {
        print('Firebase Authentication Exception: ${e.code}/////////////');
      } else if (e.code == 'user-not-found') {
        print('Firebase Authentication Exception: ${e.code}/////////////');
      } else if (e.code == 'wrong-password') {
        print('Firebase Authentication Exception: ${e.code}/////////////');
      }
      return false;
    }
  }

// Future<void> onLogin() async {
//   if (_isValid()) {
//     _status.value = RxStatus.loading();
//     try {
//       //Perform login logic here
//       _status.value = RxStatus.success();
//     } catch (e) {
//       e.printError();
//       _status.value = RxStatus.error(e.toString());
//     }
//   }
// }
}
