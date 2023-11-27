import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Price Prediction',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 62, 62, 62)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Car Price Prediction'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: SfCircularChart(
                title: ChartTitle(text: 'Pie Chart'),
                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                series: <CircularSeries>[
                  // Render pie chart
                  PieSeries<ChartDataPie, String>(
                    dataSource: chartDataPie,
                    pointColorMapper: (ChartDataPie data, _) => data.color,
                    xValueMapper: (ChartDataPie data, _) => data.fuelType,
                    yValueMapper: (ChartDataPie data, _) => data.counts,
                    radius: '50%',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            Container(
              child: SfCartesianChart(
                title: ChartTitle(text: 'Bar Chart'),
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
                    width: 0.8,
                    spacing: 0.2,
                  ),
                ],
                primaryXAxis: CategoryAxis(),
              ),
            ),
            ElevatedButton(onPressed: loadData, child: Text('Load Data'))
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
