import 'package:get/get.dart';

import '../controllers/list_aduan_masuk_admin_controller.dart';

class ListAduanMasukAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListAduanMasukAdminController>(
      () => ListAduanMasukAdminController(),
    );
  }
}
