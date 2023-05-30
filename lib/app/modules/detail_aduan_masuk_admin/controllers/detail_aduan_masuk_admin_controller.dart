import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailAduanMasukAdminController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Object?>> getData(String docID) async {
    DocumentReference docRef = firestore.collection("aduan").doc(docID);
    return docRef.get();
  }

  void editAduan(String docID) async {
    DocumentReference docData = firestore.collection("aduan").doc(docID);

    try {
      Get.defaultDialog(
        title: "Peringatan",
        middleText: "Apakah Anda yakin ingin memproses aduan ini?",
        onConfirm: (() async {
          await docData.update({
            "status": "Diproses",
          });
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

void editAduanProses(String docID) async {
  DocumentReference docData = firestore.collection("aduan").doc(docID);
  try {
    Get.defaultDialog(
      title: "Peringatan",
      middleText: "Apakah Anda yakin ingin memproses aduan ini? Setelah Anda menekan tombol ini, maka akan ada waktu 14 hari untuk menyelesaikan aduan ini.",
      onConfirm: (() async {
        DateTime deadline = DateTime.now().add(Duration(days: 14));
        String formattedDeadline = DateFormat('dd/MM/yyyy H:mm:ss').format(deadline).toString();
        await docData.update({
          "status": "Diproses",
          "deadline": formattedDeadline,
        });
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

  void editAduanTolak(String docID) async {
    DocumentReference docData = firestore.collection("aduan").doc(docID);

    try {
      Get.defaultDialog(
        title: "Peringatan",
        middleText: "Apakah Anda yakin ingin menolak aduan ini?",
        onConfirm: (() async {
          await docData.update({
            "status": "Ditolak",
          });
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
}
