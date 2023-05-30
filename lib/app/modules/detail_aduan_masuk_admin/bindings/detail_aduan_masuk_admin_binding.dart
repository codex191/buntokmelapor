import 'package:get/get.dart';

import '../controllers/detail_aduan_masuk_admin_controller.dart';

class DetailAduanMasukAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailAduanMasukAdminController>(
      () => DetailAduanMasukAdminController(),
    );
  }
}
