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
  final List<ChartDataDoughnut> chartDataDoughnut = [];
  final List<ChartDataBar> chartDataBar = [];
  final List<ChartDataScatterLine> chartDataScatterLine = [];
  bool barChart = false;

  Future<void> loadData() async {
    var uri = 'https://bilaltariq360.github.io/Car_Price_Prediction/';

    final res = await http.get(Uri.parse(uri));
    final result = json.decode(res.body) as Map<String, dynamic>;
    setState(
      () {
        List<dynamic> fuelType = result['result']['pie_chart_data']['labels'];
        List<dynamic> fuelCount = result['result']['pie_chart_data']['values'];
        chartDataDoughnut.clear();
        for (int i = 0; i < fuelType.length; i++) {
          chartDataDoughnut.add(
            ChartDataDoughnut(
              fuelType: fuelType[i],
              counts: fuelCount[i],
              color:
                  Color.fromARGB(255, ((i * 255) - 255), 126, ((i * 75) - 75)),
            ),
          );
        }

        List<dynamic> carCompany = result['result']['bar_chart_data']['labels'];
        List<dynamic> carCompanyCounts =
            result['result']['bar_chart_data']['values'];
        chartDataBar.clear();
        for (int i = 0; i < carCompany.length; i++) {
          chartDataBar.add(
            ChartDataBar(
              carCompany: carCompany[i],
              counts: carCompanyCounts[i],
            ),
          );
        }

        List<dynamic> power = result['result']['LRM']['x_axis'];
        List<dynamic> y = result['result']['LRM']['y'];
        List<dynamic> yhat = result['result']['LRM']['yhat'];
        chartDataScatterLine.clear();
        for (int i = 0; i < power.length; i++) {
          chartDataScatterLine.add(
            ChartDataScatterLine(
                power: power[i],
                y: (y[i] <= 0) ? 0.25 : y[i],
                yhat: (yhat[i] <= 0) ? 0.25 : yhat[i]),
          );
        }
      },
    );
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
      backgroundColor: const Color.fromARGB(255, 38, 38, 38),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const SizedBox(width: 15),
                  ElevatedButton(
                      onPressed: goHome,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 243, 23),
                        foregroundColor: const Color.fromARGB(255, 38, 38, 38),
                      ),
                      child: const Icon(Icons.arrow_back)),
                ]),
                Row(children: [
                  ElevatedButton(
                      onPressed: loadData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 243, 23),
                        foregroundColor: const Color.fromARGB(255, 38, 38, 38),
                      ),
                      child: const Icon(Icons.download)),
                  const SizedBox(width: 15),
                ]),
              ],
            ),
            const SizedBox(height: 80),
            SizedBox(
              child: SfCircularChart(
                title: ChartTitle(
                    text: 'Doughnut Chart',
                    textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255))),
                legend: const Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                    alignment: ChartAlignment.center,
                    backgroundColor: Color.fromARGB(255, 57, 57, 57),
                    orientation: LegendItemOrientation.horizontal,
                    textStyle:
                        TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    title: LegendTitle(
                        text: 'Fuel Types',
                        textStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 14,
                            fontWeight: FontWeight.bold))),
                series: <CircularSeries>[
                  DoughnutSeries<ChartDataDoughnut, String>(
                    dataSource: chartDataDoughnut,
                    pointColorMapper: (ChartDataDoughnut data, _) => data.color,
                    xValueMapper: (ChartDataDoughnut data, _) => data.fuelType,
                    yValueMapper: (ChartDataDoughnut data, _) => data.counts,
                    radius: '80%',
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
            SizedBox(
              height: 700,
              child: SfCartesianChart(
                legend: const Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                    alignment: ChartAlignment.center,
                    backgroundColor: Color.fromARGB(255, 57, 57, 57),
                    orientation: LegendItemOrientation.horizontal,
                    textStyle:
                        TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    title: LegendTitle(
                        text: 'Cars and Fuel Types',
                        textStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 14,
                            fontWeight: FontWeight.bold))),
                title: ChartTitle(
                  text: 'Bar Chart',
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                series: <ChartSeries>[
                  BarSeries<ChartDataBar, String>(
                    isVisible: true,
                    color: const Color.fromARGB(255, 255, 243, 23),
                    dataSource: chartDataBar,
                    xValueMapper: (ChartDataBar data, _) => data.carCompany,
                    yValueMapper: (ChartDataBar data, _) => data.counts,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    width: 0.4,
                    spacing: 0.5,
                  ),
                  BarSeries<ChartDataDoughnut, String>(
                    isVisible: false,
                    color: const Color.fromARGB(255, 255, 243, 23),
                    dataSource: chartDataDoughnut,
                    xValueMapper: (ChartDataDoughnut data, _) => data.fuelType,
                    yValueMapper: (ChartDataDoughnut data, _) => data.counts,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    width: 0.4,
                    spacing: 0.5,
                  ),
                ],
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(
                        255, 255, 255, 255), // Change the label color here
                  ),
                  majorGridLines: const MajorGridLines(
                    color: Color.fromARGB(100, 255, 23, 124),
                  ),
                ),
                primaryYAxis: NumericAxis(
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(
                        255, 255, 255, 255), // Change the label color here
                  ),
                  majorGridLines: const MajorGridLines(
                      color: Color.fromARGB(100, 255, 23, 124)),
                ),
              ),
            ),
            const SizedBox(height: 100),
            SizedBox(
              height: 500,
              child: SfCartesianChart(
                legend: const Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                    alignment: ChartAlignment.center,
                    backgroundColor: Color.fromARGB(255, 57, 57, 57),
                    orientation: LegendItemOrientation.horizontal,
                    textStyle:
                        TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    title: LegendTitle(
                        text: 'Y and YHAT',
                        textStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 14,
                            fontWeight: FontWeight.bold))),
                title: ChartTitle(
                  text: 'Scatter Graph',
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                series: <ChartSeries>[
                  ScatterSeries<ChartDataScatterLine, double>(
                    color: const Color.fromARGB(255, 255, 23, 124),
                    dataSource: chartDataScatterLine,
                    xValueMapper: (ChartDataScatterLine data, _) => data.power,
                    yValueMapper: (ChartDataScatterLine data, _) => data.y,
                  ),
                  ScatterSeries<ChartDataScatterLine, double>(
                    color: const Color.fromARGB(255, 255, 243, 23),
                    dataSource: chartDataScatterLine,
                    xValueMapper: (ChartDataScatterLine data, _) => data.power,
                    yValueMapper: (ChartDataScatterLine data, _) => data.yhat,
                  ),
                ],
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(
                        255, 255, 255, 255), // Change the label color here
                  ),
                ),
                primaryYAxis: NumericAxis(
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartDataDoughnut {
  final String fuelType;
  final int counts;
  final Color color;

  ChartDataDoughnut(
      {required this.fuelType, required this.counts, required this.color});
}

class ChartDataBar {
  final String carCompany;
  final int counts;

  ChartDataBar({required this.carCompany, required this.counts});
}

class ChartDataScatterLine {
  final double power;
  final double y;
  final double yhat;

  ChartDataScatterLine(
      {required this.power, required this.y, required this.yhat});
}
