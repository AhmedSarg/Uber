import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {

  final _status = Rx<RxStatus>(RxStatus.empty());

  RxStatus get status => _status.value;

  final feedbackController = TextEditingController();
  final feedbackFocusNode = FocusNode();

  @override
  void onClose() {
    feedbackController.dispose();
    feedbackFocusNode.dispose();
  }
}
