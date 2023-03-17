import 'package:buntokmelapor/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;

  Future<void> login() async {
    // Get.offAllNamed(Routes.HOME);
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.signIn().then((value) => _currentUser = value);
      await _googleSignIn.isSignedIn().then((value) {
        if (value) {
          // kondisi sudah llogin
          print("Berhasil Login");
          print(_currentUser);
          isAuth.value = true;
          Get.offAllNamed(Routes.HOME);
        } else {
          //kondisi tidak login
          print("Tidak berhasil Login");
        }
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
