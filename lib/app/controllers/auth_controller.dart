import 'package:buntokmelapor/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;

  Future<void> login() async {
    // Get.offAllNamed(Routes.HOME);
    try {
      //Menghandle bocornya data user sebelum login
      await _googleSignIn.signOut();

      // Untuk mendapatkan user google account
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      // Untuk mengecek status login user
      final isSignin = await _googleSignIn.isSignedIn();

      if (isSignin) {
        // kondisi sudah llogin
        print("Berhasil Login");
        print(_currentUser);

        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);
        print("user credential");
        print(userCredential);

        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
      } else {
        //kondisi tidak login
        print("Tidak berhasil Login");
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
