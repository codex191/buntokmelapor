import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';

class FeedbackPageController extends GetxController {
  //TODO: Implement FeedbackPageController
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
