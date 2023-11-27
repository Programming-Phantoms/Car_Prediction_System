import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';

class Charts extends StatefulWidget {
  static String routeName = '/chart-page';
  const Charts({super.key, required this.title});

  final String title;

  @override
  State<Charts> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Charts> {
  final List<ChartDataPie> chartDataPie = [];
  final List<ChartDataBar> chartDataBar = [];

  Future<void> loadData() async {
    var uri = 'https://bilaltariq360.github.io/Car_Price_Prediction/';

    final res = await http.get(Uri.parse(uri));
    final result = json.decode(res.body) as Map<String, dynamic>;
    setState(() {
      List<dynamic> fuelType = result['fuel_distribution']['labels'];
      List<dynamic> fuelCount = result['fuel_distribution']['values'];
      chartDataPie.clear();
      for (int i = 0; i < fuelType.length; i++) {
        chartDataPie.add(ChartDataPie(
          fuelType: fuelType[i],
          counts: fuelCount[i],
          color: Color.fromARGB(255, ((i * 255) - 255), 126, ((i * 75) - 75)),
        ));
      }

      List<dynamic> carCompany = result['number_of_cars_by_company']['labels'];
      List<dynamic> carCompanyCounts =
          result['number_of_cars_by_company']['values'];
      chartDataBar.clear();
      for (int i = 0; i < carCompany.length; i++) {
        chartDataBar.add(ChartDataBar(
          carCompany: carCompany[i],
          counts: carCompanyCounts[i],
        ));
      }
    });
  }

  void goHome() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: goHome,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black, // background color
                    onPrimary: Colors.white, // text color
                  ),
                  child: Row(children: [
                    Icon(Icons.arrow_back),
                    SizedBox(width: 5),
                    Text('Go Back')
                  ]),
                ),
                ElevatedButton(
                  onPressed: loadData,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black, // background color
                    onPrimary: Colors.white, // text color
                  ),
                  child: Row(children: [
                    Icon(Icons.download),
                    SizedBox(width: 5),
                    Text('Fetch Data')
                  ]),
                ),
              ],
            ),
            SizedBox(height: 80),
            Container(
              child: SfCircularChart(
                title: ChartTitle(
                    text: 'Doughnut Chart',
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                legend: const Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                series: <CircularSeries>[
                  DoughnutSeries<ChartDataPie, String>(
                    dataSource: chartDataPie,
                    pointColorMapper: (ChartDataPie data, _) => data.color,
                    xValueMapper: (ChartDataPie data, _) => data.fuelType,
                    yValueMapper: (ChartDataPie data, _) => data.counts,
                    radius: '80%',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            SizedBox(height: 100),
            Container(
              child: SfCartesianChart(
                title: ChartTitle(
                    text: 'Bar Chart',
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                series: <ChartSeries>[
                  // Renders bar chart
                  BarSeries<ChartDataBar, String>(
                    dataSource: chartDataBar,
                    xValueMapper: (ChartDataBar data, _) => data.carCompany,
                    yValueMapper: (ChartDataBar data, _) => data.counts,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    width: 0.7,
                    spacing: 0.2,
                  ),
                ],
                primaryXAxis: CategoryAxis(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartDataPie {
  final String fuelType;
  final int counts;
  final Color color;

  ChartDataPie(
      {required this.fuelType, required this.counts, required this.color});
}

class ChartDataBar {
  final String carCompany;
  final int counts;

  ChartDataBar({required this.carCompany, required this.counts});
}
