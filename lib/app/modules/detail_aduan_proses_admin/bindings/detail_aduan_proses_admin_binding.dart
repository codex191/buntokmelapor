import 'package:get/get.dart';

import '../controllers/detail_aduan_proses_admin_controller.dart';

class DetailAduanProsesAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailAduanProsesAdminController>(
      () => DetailAduanProsesAdminController(),
    );
  }
}
