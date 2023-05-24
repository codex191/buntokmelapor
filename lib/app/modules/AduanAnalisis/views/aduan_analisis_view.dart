import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../data/models/aduan_model.dart';
import '../controllers/aduan_analisis_controller.dart';

class AduanAnalisisView extends GetView<AduanAnalisisController> {
  const AduanAnalisisView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analisis Data Aduan'),
      ),
      body: Obx(
        () => controller.chartData.isNotEmpty
            ? SfCircularChart(
                title: ChartTitle(text: 'Jumlah Aduan Berdasarkan Kategori'),
                series: <CircularSeries>[
                  DoughnutSeries<Map<String, dynamic>, String>(
                    dataSource: controller.chartData,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['kategori'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) =>
                        data['jumlah'] as int,
                    pointColorMapper: (Map<String, dynamic> data, _) {
                      switch (data['kategori']) {
                        // You can add more cases to customize the colors
                        case 'Kerusakan Fasilitas Publik':
                          return Colors.red;
                        case 'Kerusakan Jalan':
                          return Colors.green;
                        case 'Pendidikan':
                          return Colors.blue;
                        case 'Ketertiban & Keamanan':
                          return Colors.yellow;
                          case 'Lainnya':
                          return Colors.grey;
                        default:
                          return Colors.grey;
                      }
                    },
                    explode: true,
                    explodeIndex: 0,
                    dataLabelMapper: (Map<String, dynamic> data, _) =>
                        '${data['kategori']} (${data['jumlah']})',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  )
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
