import 'package:get/get.dart';

import '../controllers/feedback_page_controller.dart';

class FeedbackPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedbackPageController>(
      () => FeedbackPageController(),
    );
  }
}
