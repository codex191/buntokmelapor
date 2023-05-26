import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FeedbackPageController extends GetxController {
  late TextEditingController kritikC;
  late TextEditingController saranC;

  @override
  void onInit() {
    kritikC = TextEditingController();
    saranC = TextEditingController();

    super.onInit();
  }

  @override
  void onClose() {
    kritikC.dispose();
    saranC.dispose();
    super.onClose();
  }
}
