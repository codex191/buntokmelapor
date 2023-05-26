
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/auth_controller.dart';

class AduanPageController extends GetxController {
  final AuthController authC = Get.find<AuthController>();
  RxString judul = ''.obs;
  RxString deskripsi = ''.obs;
  RxString kategori = ''.obs;
  RxString gambarUrl = ''.obs;

  Future<void> kirimAduan() async {
    if (judul.isEmpty || deskripsi.isEmpty || kategori.isEmpty) {
      Get.snackbar(
        'Error',
        'Silakan lengkapi data aduan terlebih dahulu.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final tanggal = DateFormat('dd/MM/yyyy H:mm:ss').format(DateTime.now());

    try {
      await FirebaseFirestore.instance.collection('aduan').doc(id).set({
        'id': id,
        'judul': judul.value,
        'deskripsi': deskripsi.value,
        'pengirim': authC.user.value.name,
        'pengadu': authC.user.value.email,
        'kategori': kategori.value,
        'gambarUrl': gambarUrl.value,
        'tanggal': tanggal,
        'status': 'Belum Ditanggapi',
      });

      judul.value = '';
      deskripsi.value = '';
      kategori.value = '';
      gambarUrl.value = '';

      Get.back();

      // Menampilkan notifikasi berhasil
      Get.snackbar(
        'Berhasil',
        'Aduan berhasil dikirim.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      // Menampilkan notifikasi gagal
      Get.snackbar(
        'Error',
        'Terjadi kesalahan dalam mengirim aduan. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }
}
