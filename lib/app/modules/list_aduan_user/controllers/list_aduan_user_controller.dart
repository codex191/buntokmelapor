import 'package:get/get.dart';

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../controllers/auth_controller.dart';

class ListAduanUserController extends GetxController {
  final authC = Get.find<AuthController>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> streamAduan() {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore.collection("aduan").snapshots();
  }

  Stream<QuerySnapshot<Object?>> streamData() {
    Query aduan = firestore
        .collection("aduan")
        .where("pengadu",
            isEqualTo: authC.user.value.email) // Memfilter berdasarkan pengadu
        .orderBy("tanggal",
            descending: true); // Mengurutkan berdasarkan tanggal
    return aduan.snapshots();
  }
}
