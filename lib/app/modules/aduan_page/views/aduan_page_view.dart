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
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

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
    return TextField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey[400]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
      ),
      onChanged: onChanged,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat aduan'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          _buildTextField(
            label: 'Judul',
            onChanged: (judul) => controller.judul.value = judul,
          ),
          SizedBox(height: 20),
          _buildTextField(
            label: 'Deskripsi',
            onChanged: (deskripsi) => controller.deskripsi.value = deskripsi,
            minLines: 5,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
          ),
          SizedBox(height: 20),
          Text(
            'Kategori',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
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
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey[400]!,
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
          SizedBox(height: 20),
          _buildTextField(
            controller: null,
            label: 'URL Gambar (opsional)',
            onChanged: (url) => controller.gambarUrl.value = url,
          ),
          SizedBox(height: 20),
          _selectedImage != null
              ? Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _selectedImage!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: _removeImage,
                        child: Text(
                          'Hapus Gambar',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text('Pilih Gambar'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, 
              backgroundColor: Colors.grey[200],
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              controller.gambarUrl.value = await _uploadImage() ?? '';
            },
            child: Text('Upload Gambar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => controller.kirimAduan(),
            icon: Icon(Icons.send),
            label: Text('Kirim'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}