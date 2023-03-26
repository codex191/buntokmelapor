import 'package:get/get.dart';

import '../controllers/aduan_page_controller.dart';

class AduanPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AduanPageController>(
      () => AduanPageController(),
    );
  }
}
