import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controllers/aduan_analisis_controller.dart';

class AduanAnalisisView extends GetView<AduanAnalisisController> {
  const AduanAnalisisView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analisis Data Aduan'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                        child: Text(
                          'Berdasarkan Kategori',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Berdasarkan Bulan',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Berdasarkan Tahun',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      children: [
                        Obx(
                          () => controller.chartData.isNotEmpty
                              ? ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 500),
                                  child: SfCircularChart(
                                    title: ChartTitle(
                                        text:
                                            'Jumlah Aduan Berdasarkan Kategori'),
                                    series: <CircularSeries>[
                                      DoughnutSeries<Map<String, dynamic>,
                                          String>(
                                        dataSource: controller.chartData,
                                        xValueMapper:
                                            (Map<String, dynamic> data, _) =>
                                                data['kategori'] as String,
                                        yValueMapper:
                                            (Map<String, dynamic> data, _) =>
                                                data['jumlah'] as int,
                                        pointColorMapper:
                                            (Map<String, dynamic> data, _) {
                                          switch (data['kategori']) {
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
                                        dataLabelMapper: (Map<String, dynamic>
                                                    data,
                                                _) =>
                                            '${data['kategori']} (${data['jumlah']})',
                                        dataLabelSettings:
                                            DataLabelSettings(isVisible: true),
                                      )
                                    ],
                                  ),
                                )
                              : Center(child: CircularProgressIndicator()),
                        ),
                        Obx(
                          () => controller.chartDataByMonth.isNotEmpty
                              ? ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 500),
                                  child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    title: ChartTitle(
                                        text: 'Jumlah Aduan Berdasarkan Bulan'),
                                      series: <CartesianSeries<Map<String, dynamic>, String>>[
    ColumnSeries<Map<String, dynamic>, String>(
      dataSource: controller.chartDataByMonth,
      xValueMapper: (Map<String, dynamic> data, _) => data['bulan'] as String,
      yValueMapper: (Map<String, dynamic> data, _) => data['jumlah'] as int,
      dataLabelSettings: const DataLabelSettings(isVisible: true),
    )
  ],
                                  ),
                                )
                              : Center(child: CircularProgressIndicator()),
                        ),
                        Obx(
                          () => controller.chartDataByYear.isNotEmpty
                              ? ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 500),
                                  child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    title: ChartTitle(
                                        text: 'Jumlah Aduan Berdasarkan Tahun'),
                                      series: <CartesianSeries<Map<String, dynamic>, String>>[
    ColumnSeries<Map<String, dynamic>, String>(
      dataSource: controller.chartDataByYear,
      xValueMapper: (Map<String, dynamic> data, _) => data['tahun'] as String,
      yValueMapper: (Map<String, dynamic> data, _) => data['jumlah'] as int,
      dataLabelSettings: const DataLabelSettings(isVisible: true),
    )
  ],
                                  ),
                                )
                              : Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
