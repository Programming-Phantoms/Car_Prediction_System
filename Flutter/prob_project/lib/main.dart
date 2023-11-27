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
  final List<ChartDataPie> chartData = [];

  Future<void> loadData() async {
    var uri = 'http://127.0.0.1:5000/';

    final res = await http.get(Uri.parse(uri));
    final result = json.decode(res.body) as Map<String, dynamic>;
    setState(() {
      List<dynamic> labels = result['fuel_distribution']['labels'];
      List<dynamic> values = result['fuel_distribution']['values'];
      chartData.clear();
      for (int i = 0; i < labels.length; i++) {
        chartData.add(ChartDataPie(
          name: labels[i],
          price: values[i],
          color: Color.fromARGB(255, 144 * i, 17 * i, 100 * i),
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
      body: Center(
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
                    dataSource: chartData,
                    pointColorMapper: (ChartDataPie data, _) => data.color,
                    xValueMapper: (ChartDataPie data, _) => data.name,
                    yValueMapper: (ChartDataPie data, _) => data.price,
                    radius: '50%',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
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
  final String name;
  final int price;
  final Color color;

  ChartDataPie({required this.name, required this.price, required this.color});
}
