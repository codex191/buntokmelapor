import 'package:get/get.dart';

import '../controllers/detail_aduan_selesai_admin_controller.dart';

class DetailAduanSelesaiAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailAduanSelesaiAdminController>(
      () => DetailAduanSelesaiAdminController(),
    );
  }
}
