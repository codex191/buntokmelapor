import 'dart:io';

import 'package:buntokmelapor/app/controllers/auth_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/aduan_page_controller.dart';

// ignore: must_be_immutable
class AduanPageView extends GetView<AduanPageController> {
  final AuthController userController = Get.find<AuthController>();
  final picker = ImagePicker();
  File? _selectedImage;

  // Method untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Set state untuk menampilkan gambar di layar
      _selectedImage = File(pickedImage.path);
    }
  }

  // Method untuk menghapus gambar
  void _removeImage() {
    controller.gambarUrl.value = '';
    _selectedImage = null;
  }

  // Method untuk mengupload gambar ke Firebase Storage
  Future<String?> _uploadImage() async {
    if (_selectedImage != null) {
      try {
        final imageUrl = await FirebaseStorage.instance
            .ref()
            .child('aduan')
            .child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg')
            .putFile(_selectedImage!)
            .then((value) => value.ref.getDownloadURL());
        return imageUrl;
      } catch (error) {
        // Handle error
        return null;
      }
    }

    return null;
  }

  Widget _buildTextField({
    TextEditingController? controller,
    String? label,
    int? maxLines,
    int? minLines,
    TextInputType? keyboardType,
    bool readOnly = false,
    void Function(String)? onChanged,
  }) {
    return CupertinoTextField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      placeholder: label,
      placeholderStyle: TextStyle(
        color: CupertinoColors.placeholderText,
      ),
      onChanged: onChanged,
      decoration: BoxDecoration(
        border: Border.all(
          color: CupertinoColors.separator,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  final categories = <String>[
    "Kerusakan Jalan",
    "Kerusakan Fasilitas Publik",
    "Pelayanan Publik",
    "Pendidikan",
    "Ketertiban & Keamanan",
    "Lainnya"
  ];
  String? selectedCategory;

  Widget _buildCategoryPicker() {
    return Container(
      height: 200,
      child: CupertinoPicker(
        itemExtent: 30.0,
        children: categories.map((category) {
          return Text(
            category,
            style: TextStyle(fontSize: 18.0),
          );
        }).toList(),
        onSelectedItemChanged: (selectedIndex) {
          controller.kategori.value = categories[selectedIndex];
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Buat aduan'),
      ),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            _buildTextField(
              label: 'Judul',
              onChanged: (judul) => controller.judul.value = judul,
            ),
            SizedBox(height: 10),
            _buildTextField(
              label: 'Deskripsi',
              onChanged: (deskripsi) => controller.deskripsi.value = deskripsi,
              minLines: 5,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 10),
            SizedBox(height: 10),
            Text(
              'Kategori',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: 250,
                      child: _buildCategoryPicker(),
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                child: Obx(
                  () => Text(
                    controller.kategori.value,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildTextField(
              controller: null,
              label: 'URL Gambar (opsional)',
              onChanged: (url) => controller.gambarUrl.value = url,
            ),
            SizedBox(height: 10),
            _selectedImage != null
                ? Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.file(
                          _selectedImage!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: _removeImage,
                          child: Text(
                            'Hapus Gambar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text('Pilih Gambar'),
            ),
            ElevatedButton(
              onPressed: () async {
                controller.gambarUrl.value = await _uploadImage() ?? '';
              },
              child: Text('Upload Gambar'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => controller.kirimAduan(),
              icon: Icon(Icons.send),
              label: Text('Kirim'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green.shade800,
                fixedSize: Size(double.infinity, 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
