import 'package:buntokmelapor/app/controllers/auth_controller.dart';
import 'package:buntokmelapor/app/utils/error_screen.dart';
import 'package:buntokmelapor/app/utils/loading_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/utils/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final authC = Get.put(AuthController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          //Cek Error
          if (snapshot.hasError) {
            return ErrorScreen();
          }

          //Jika berhasil, akan menampilkan halaman aplikasi
          if (snapshot.connectionState == ConnectionState.done) {
            return FutureBuilder(
              future: Future.delayed(Duration(seconds: 3)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Obx(
                    () => GetMaterialApp(
                      title: "BuntokMelapor",
                      initialRoute: authC.isSkipIntro.isTrue
                          ? authC.isAuth.isTrue
                              ? Routes.HOME
                              : Routes.HOME
                          : Routes.INTRODUCTION,
                      getPages: AppPages.routes,
                    ),
                  );
                }
                return SplashScreen();
              },
            );
          }

          //Jika tidak berhasil, akan menampilkan
          return LoadingScreen();
        });
  }
}
