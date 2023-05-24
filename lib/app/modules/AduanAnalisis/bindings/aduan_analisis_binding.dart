import 'package:get/get.dart';

import '../controllers/aduan_analisis_controller.dart';

class AduanAnalisisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AduanAnalisisController>(
      () => AduanAnalisisController(),
    );
  }
}
