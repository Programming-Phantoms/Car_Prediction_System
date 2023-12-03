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
  final List<ChartDataPie> chartDataDoughnut = [];
  final List<ChartDataBar> chartDataBar = [];
  final List<ChartDataScatterLine> chartDataScatterLine = [];
  bool loading = true;

  Future<void> _simulateLoading() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      loading = false;
    });
  }

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
            ChartDataPie(
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
    _simulateLoading();
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
      body: (loading)
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 255, 243, 23)),
                ),
                SizedBox(height: 20),
                Text(
                  'Fetching Data...',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              ],
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        const SizedBox(width: 15),
                        InkWell(
                          borderRadius: BorderRadius.circular(20.0),
                          onTap: goHome,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 255, 243, 23)),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Color.fromARGB(255, 38, 38, 38),
                              size: 20.0,
                            ),
                          ),
                        ),
                      ]),
                      Row(children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(20.0),
                          onTap: loadData,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 255, 243, 23)),
                            child: const Icon(
                              Icons.file_download_rounded,
                              color: Color.fromARGB(255, 38, 38, 38),
                              size: 20.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 80),
                  SizedBox(
                    width: 750,
                    child: SfCircularChart(
                      title: ChartTitle(
                        text: 'Pie Chart',
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      legend: const Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap,
                        alignment: ChartAlignment.center,
                        backgroundColor: Color.fromARGB(255, 57, 57, 57),
                        orientation: LegendItemOrientation.horizontal,
                        textStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                        title: LegendTitle(
                          text: 'Fuel Types',
                          textStyle: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      series: <PieSeries<ChartDataPie, String>>[
                        PieSeries<ChartDataPie, String>(
                          dataSource: chartDataDoughnut,
                          xValueMapper: (ChartDataPie data, _) => data.fuelType,
                          yValueMapper: (ChartDataPie data, _) => data.counts,
                          dataLabelMapper: (ChartDataPie data, _) =>
                              '${((data.counts / 6019) * 100).toStringAsFixed(2)}%',
                          radius: '60%',
                          dataLabelSettings: const DataLabelSettings(
                            margin: EdgeInsets.zero,
                            isVisible: true,
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 14),
                            labelPosition: ChartDataLabelPosition.outside,
                            connectorLineSettings: ConnectorLineSettings(
                                type: ConnectorType.curve, length: '50%'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                  SizedBox(
                    height: 700,
                    width: 1200,
                    child: SfCartesianChart(
                      legend: const Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap,
                          alignment: ChartAlignment.center,
                          backgroundColor: Color.fromARGB(255, 57, 57, 57),
                          orientation: LegendItemOrientation.horizontal,
                          textStyle: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
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
                            xValueMapper: (ChartDataBar data, _) =>
                                data.carCompany,
                            yValueMapper: (ChartDataBar data, _) => data.counts,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            width: 0.4,
                            spacing: 0.5,
                            name: 'Car Brands'),
                        BarSeries<ChartDataPie, String>(
                            isVisible: false,
                            color: const Color.fromARGB(255, 255, 243, 23),
                            dataSource: chartDataDoughnut,
                            xValueMapper: (ChartDataPie data, _) =>
                                data.fuelType,
                            yValueMapper: (ChartDataPie data, _) => data.counts,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            width: 0.4,
                            spacing: 0.5,
                            name: 'Fuels'),
                      ],
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 255, 255,
                              255), // Change the label color here
                        ),
                        majorGridLines: const MajorGridLines(
                          color: Color.fromARGB(100, 255, 23, 124),
                        ),
                      ),
                      primaryYAxis: NumericAxis(
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 255, 255,
                              255), // Change the label color here
                        ),
                        majorGridLines: const MajorGridLines(
                            color: Color.fromARGB(100, 255, 23, 124)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  SizedBox(
                    height: 500,
                    width: 1200,
                    child: SfCartesianChart(
                      legend: const Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap,
                          alignment: ChartAlignment.center,
                          backgroundColor: Color.fromARGB(255, 57, 57, 57),
                          orientation: LegendItemOrientation.horizontal,
                          textStyle: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
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
                            xValueMapper: (ChartDataScatterLine data, _) =>
                                data.power,
                            yValueMapper: (ChartDataScatterLine data, _) =>
                                data.y,
                            markerSettings: const MarkerSettings(
                                width: 7,
                                height: 7,
                                shape: DataMarkerType.circle),
                            name: 'Orig. price'),
                        ScatterSeries<ChartDataScatterLine, double>(
                            color: const Color.fromARGB(255, 255, 243, 23),
                            dataSource: chartDataScatterLine,
                            xValueMapper: (ChartDataScatterLine data, _) =>
                                data.power,
                            yValueMapper: (ChartDataScatterLine data, _) =>
                                data.yhat,
                            markerSettings: const MarkerSettings(
                                width: 7,
                                height: 7,
                                shape: DataMarkerType.circle),
                            name: 'Pred. Price'),
                      ],
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 255, 255,
                              255), // Change the label color here
                        ),
                        majorGridLines: const MajorGridLines(
                            color: Color.fromARGB(100, 255, 23, 124)),
                      ),
                      primaryYAxis: NumericAxis(
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        majorGridLines: const MajorGridLines(
                            color: Color.fromARGB(100, 255, 23, 124)),
                      ),
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

class ChartDataScatterLine {
  final double power;
  final double y;
  final double yhat;

  ChartDataScatterLine(
      {required this.power, required this.y, required this.yhat});
}
