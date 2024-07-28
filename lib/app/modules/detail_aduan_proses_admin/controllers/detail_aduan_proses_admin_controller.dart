import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/notification_helper.dart';

class DetailAduanProsesAdminController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late TextEditingController catatan = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    catatan = TextEditingController();
  }

  Future<DocumentSnapshot<Object?>> getData(String docID) async {
    DocumentReference docRef = firestore.collection("aduan").doc(docID);
    return docRef.get();
  }

  void editAduanSelesai(String docID) async {
    DocumentReference docData = firestore.collection("aduan").doc(docID);
    try {
      Get.defaultDialog(
        title: "Peringatan",
        middleText:
            "Apakah Anda yakin ingin menyelesaikan aduan ini? Setelah Anda menekan tombol ini, aduan tidak dapat diubah lagi.",
        onConfirm: (() async {
          await docData.update({
            "status": "Selesai",
          });
          showNotification('Aduan telah selesai', 'Aduan yang Anda laporkan telah selesai diproses.');
          Get.back();
        }),
        onCancel: () {},
      );
    } catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: "Tidak dapat menyelesaikan aduan",
      );
    }
  }

  @override
  void dispose() {
    catatan.dispose();
    super.dispose();
  }
}
