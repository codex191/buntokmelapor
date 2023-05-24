import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/models/aduan_model.dart';

class AduanAnalisisController extends GetxController {
  RxList<Map<String, dynamic>> _chartData = RxList<Map<String, dynamic>>([]);

  List<Map<String, dynamic>> get chartData => _chartData;

    @override
  void onInit() {
    _fetchData();
    super.onInit();
  }

  static CollectionReference collection =
      FirebaseFirestore.instance.collection('aduan');

  static Future<List<Aduan>> getAduanList() async {
    QuerySnapshot querySnapshot = await collection.get();

    List<Aduan> aduanList = [];
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data =
          (doc.data() ?? {}) as Map<String, dynamic>?; // added line
      aduanList.add(Aduan.fromMap(data!, doc.id));
    });

    return aduanList;
  }
Future<void> _fetchData() async {
  CollectionReference aduanCollection = FirebaseFirestore.instance.collection('aduan');
  QuerySnapshot querySnapshot = await aduanCollection.get();

  Map<String, int> kategoriCountMap = {};
  querySnapshot.docs.forEach((doc) {
    // Get Aduan data
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String kategori = data['kategori'] ?? 'Lain-lain';
    kategoriCountMap.update(
      kategori,
      (value) => value + 1,
      ifAbsent: () => 1,
    );
  });

  // Clear chart data
  chartData.clear();

  // Generate new chart data from query result
  kategoriCountMap.forEach((kategori, count) {
    chartData.add({'kategori': kategori, 'jumlah': count});
  });

  // Update Obx widgets that are listening to chartData changes
  _chartData.refresh();
}
}
