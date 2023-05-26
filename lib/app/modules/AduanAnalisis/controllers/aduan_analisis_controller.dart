import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class AduanAnalisisController extends GetxController {
  RxList<Map<String, dynamic>> _chartData =
      RxList<Map<String, dynamic>>([]);
  RxList<Map<String, dynamic>> _chartDataByMonth =
      RxList<Map<String, dynamic>>([]);
  RxList<Map<String, dynamic>> _chartDataByYear =
      RxList<Map<String, dynamic>>([]);

  List<Map<String, dynamic>> get chartData => _chartData;
  List<Map<String, dynamic>> get chartDataByMonth => _chartDataByMonth;
  List<Map<String, dynamic>> get chartDataByYear => _chartDataByYear;

  @override
  void onInit() {
    _fetchData();
    super.onInit();
  }
  

  Future<void> _fetchData() async {
    CollectionReference aduanCollection =
        FirebaseFirestore.instance.collection('aduan');
    QuerySnapshot querySnapshot = await aduanCollection.get();

    Map<String, int> kategoriCountMap = {};
    Map<String, int> bulanCountMap = {};
    Map<String, int> tahunCountMap = {};

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String kategori = data['kategori'] ?? 'Lain-lain';
      String tanggal = data['tanggal'] ?? '';
      if (tanggal.isNotEmpty) {
        DateTime date = DateFormat('dd/MM/yyyy H:mm:ss').parse(tanggal);
        String bulan = DateFormat('MM/yyyy').format(date);
        String tahun = DateFormat('yyyy').format(date);
        kategoriCountMap.update(
          kategori,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
        bulanCountMap.update(
          bulan,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
        tahunCountMap.update(
          tahun,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
    });

    chartData.assignAll(kategoriCountMap.entries.map((entry) =>
        {'kategori': entry.key, 'jumlah': entry.value}).toList());
    chartDataByMonth.assignAll(bulanCountMap.entries.map((entry) =>
        {'bulan': entry.key, 'jumlah': entry.value}).toList());
    chartDataByYear.assignAll(tahunCountMap.entries.map((entry) =>
        {'tahun': entry.key, 'jumlah': entry.value}).toList());
  }

  
}