import 'package:buntokmelapor/app/utils/error_page.dart';
import 'package:buntokmelapor/app/utils/loading_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          //Cek Error
          if (snapshot.hasError) {
            return ErrorPage();
          }

          //Jika berhasil, akan menampilkan halaman aplikasi
          if (snapshot.connectionState == ConnectionState.done) {
            return GetMaterialApp(
              title: "Application",
              initialRoute: AppPages.INITIAL,
              getPages: AppPages.routes,
            );
          }

          //Jika tidak berhasil, akan menampilkan
          return LoadingPage();
        });
  }
}
