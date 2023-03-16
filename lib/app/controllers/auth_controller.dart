import 'package:buntokmelapor/app/routes/app_pages.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  void login() {
    Get.offAllNamed(Routes.HOME);
  }
}
