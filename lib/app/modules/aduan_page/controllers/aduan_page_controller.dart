import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../controllers/auth_controller.dart';

class AduanPageController extends GetxController {
  final authC = Get.find<AuthController>();
  var judul = ''.obs;
  var deskripsi = ''.obs;
  var kategori = ''.obs;
  var gambarUrl = ''.obs;
  var tanggal = ''.obs;

  void kirimAduan() async {
    if (judul.value.isEmpty ||
        deskripsi.value.isEmpty ||
        kategori.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Silakan lengkapi data aduan terlebih dahulu.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } else {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final tanggal =
          DateFormat('dd/MM/yyyy H:mm:ss').format(DateTime.now()).toString();

      try {
        await FirebaseFirestore.instance.collection('aduan').doc(id).set({
          'id': id,
          'judul': judul.value,
          'deskripsi': deskripsi.value,
          'pengirim': authC.user.value.name,
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
}
