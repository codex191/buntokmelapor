import 'package:get/get.dart';

import '../controllers/pertanyaan_controller.dart';

class PertanyaanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PertanyaanController>(
      () => PertanyaanController(),
    );
  }
}
