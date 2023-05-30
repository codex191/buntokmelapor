import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListAduanProsesAdminController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    getAduanList();
    super.onInit();
  }

Stream<QuerySnapshot<Object?>> getAduanList() {
  try {
    Stream<QuerySnapshot<Object?>> aduan = firestore
        .collection("aduan")
        .where("status", isEqualTo: "Diproses")
        .snapshots();

    return aduan;
  } catch (e) {
    Get.snackbar(
      'Error',
      'Terjadi kesalahan dalam mengambil data. Silakan coba lagi.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    rethrow;
  }
}

  @override
  void onClose() {
    super.onClose();
  }

}
