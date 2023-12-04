import 'package:car_price_prediction/components/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../components/dropdown.dart';
import '../components/button.dart';

class Charts extends StatefulWidget {
  static String routeName = '/chart-page';
  const Charts({super.key, required this.title});

  final String title;

  @override
  State<Charts> createState() => ChartsClass();
}

class ChartsClass extends State<Charts> {
  final List<ChartDataPie> chartDataDoughnut = [];
  final List<ChartDataBar> chartDataBar = [];
  final List<ChartDataScatterLine> chartDataScatterLine = [];
  List<dynamic> parameters = [];
  List<dynamic> variables = [];
  bool loading = true;
  final kilometerDriven = TextEditingController();
  final mileage = TextEditingController();
  final engine = TextEditingController();
  final power = TextEditingController();
  final seats = TextEditingController();
  static String year = '';
  static String carBrand = '';
  static String fuelType = '';
  static String transmission = '';
  static String ownerType = '';
  static String location = '';
  static String kilometer = '';
  static String mileageStr = '';
  static String powerStr = '';
  static String engineStr = '';
  static String seatStr = '';

  String result = '0';

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
    var uri = 'http://127.0.0.1:5000';

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
                y: (y[i] <= 0) ? 0.00000082389626505374 : y[i],
                yhat: (yhat[i] <= 0) ? 0.00000082389626505374 : yhat[i]),
          );
        }

        parameters = result['result']['LRM']['Parameters'];
        variables = result['result']['LRM']['Variables'];
      },
    );
    _simulateLoading();
  }

  void goHome() {
    Navigator.pop(context);
  }

  void predict() {
    double yearP = double.parse(ChartsClass.year) * parameters[0];
    double kilometerP = double.parse(ChartsClass.kilometer) * parameters[1];
    double mileageP = double.parse(ChartsClass.mileageStr) * parameters[2];
    double engineP = double.parse(ChartsClass.kilometer) * parameters[3];
    double powerP = double.parse(ChartsClass.kilometer) * parameters[4];
    double seatsP = double.parse(ChartsClass.kilometer) * parameters[5];
    int i = 0;
    for (i = 0; i < variables.length; i++) {
      if (variables[i] == 'Location_${ChartsClass.location}') {
        break;
      }
    }
    double locP = 1.0 * parameters[i];
    for (i = 0; i < variables.length; i++) {
      if (variables[i] == 'Location_${ChartsClass.carBrand}') {
        break;
      }
    }
    double carBrandP = 1.0 * parameters[i];
    double locP = 1.0 * parameters[i];
    setState(() {
      result = (yearP + kilometerP + mileageP + engineP + powerP + seatsP)
          .toStringAsFixed(2);
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    const SizedBox(height: 50),
                    const Text('Price Prediction Parameters',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 70),
                    const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 180,
                            child: MyDropdown(
                                hintText: 'Year',
                                list: [
                                  '1998',
                                  '1999',
                                  '2000',
                                  '2001',
                                  '2002',
                                  '2003',
                                  '2004',
                                  '2005',
                                  '2006',
                                  '2007',
                                  '2008',
                                  '2009',
                                  '2010',
                                  '2011',
                                  '2012',
                                  '2013',
                                  '2014',
                                  '2015',
                                  '2016',
                                  '2017',
                                  '2018',
                                  '2019'
                                ],
                                prefixIcon: Icons.calendar_month_outlined),
                          ),
                          SizedBox(
                            width: 250,
                            child: MyDropdown(
                                hintText: 'Car Brand',
                                list: [
                                  'Audi',
                                  'Ambassador',
                                  'Bentley',
                                  'BMW',
                                  'Chevrolet',
                                  'Datsun',
                                  'Fiat',
                                  'Ford',
                                  'Force',
                                  'Honda',
                                  'Isuzu',
                                  'Jaguar',
                                  'Jeep',
                                  'Lamborghini',
                                  'Land Rover',
                                  'Mahindra',
                                  'Maruti',
                                  'Mercedes-Benz',
                                  'Mini',
                                  'Mitsubishi',
                                  'Nissan',
                                  'Porsche',
                                  'Renault',
                                  'Skoda',
                                  'Smart',
                                  'Tata',
                                  'Toyota',
                                  'Volkswagen',
                                  'Volvo'
                                ],
                                prefixIcon: CupertinoIcons.car_detailed),
                          ),
                          SizedBox(
                            width: 210,
                            child: MyDropdown(
                                hintText: 'Fuel Type',
                                list: [
                                  'CNG',
                                  'Diesel',
                                  'Electric',
                                  'LPG',
                                  'Petrol'
                                ],
                                prefixIcon: Icons.filter_alt_rounded),
                          ),
                          SizedBox(
                            width: 230,
                            child: MyDropdown(
                                hintText: 'Transmission Type',
                                list: ['Automatic', 'Manual'],
                                prefixIcon: Icons.transform),
                          ),
                          SizedBox(
                            width: 220,
                            child: MyDropdown(
                                hintText: 'Owner Type',
                                list: ['Second', 'Third', 'Fourth or above'],
                                prefixIcon: Icons.people_sharp),
                          ),
                          SizedBox(
                            width: 210,
                            child: MyDropdown(
                                hintText: 'Location',
                                list: [
                                  'Bangalore',
                                  'Chennai',
                                  'Coimbatore',
                                  'Delhi',
                                  'Hyderabad',
                                  'Jaipur',
                                  'Kochi',
                                  'Kolkata',
                                  'Mumbai',
                                  'Pune'
                                ],
                                prefixIcon: CupertinoIcons.location_fill),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 280,
                            child: MyTextField(
                                controller: kilometerDriven,
                                hintText: 'Kilometer Driven',
                                obscureText: false,
                                maxLength: 8,
                                exactLength: 8,
                                minLength: 1,
                                textInputType: TextInputType.number,
                                filteringTextInputFormatter:
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                check: false,
                                prefixIcon: Icons.add_road_rounded,
                                hideCheckMark: true),
                          ),
                          SizedBox(
                            width: 200,
                            child: MyTextField(
                                controller: mileage,
                                hintText: 'Mileage',
                                obscureText: false,
                                maxLength: 8,
                                exactLength: 8,
                                minLength: 1,
                                textInputType: TextInputType.number,
                                filteringTextInputFormatter:
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                check: false,
                                prefixIcon: Icons.car_crash_rounded,
                                hideCheckMark: true),
                          ),
                          SizedBox(
                            width: 200,
                            child: MyTextField(
                                controller: power,
                                hintText: 'Power',
                                obscureText: false,
                                maxLength: 8,
                                exactLength: 8,
                                minLength: 1,
                                textInputType: TextInputType.number,
                                filteringTextInputFormatter:
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                check: false,
                                prefixIcon: Icons.power_outlined,
                                hideCheckMark: true),
                          ),
                          SizedBox(
                            width: 200,
                            child: MyTextField(
                                controller: engine,
                                hintText: 'Engine',
                                obscureText: false,
                                maxLength: 8,
                                exactLength: 8,
                                minLength: 1,
                                textInputType: TextInputType.number,
                                filteringTextInputFormatter:
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                check: false,
                                prefixIcon: Icons.energy_savings_leaf_outlined,
                                hideCheckMark: true),
                          ),
                          SizedBox(
                            width: 200,
                            child: MyTextField(
                                controller: seats,
                                hintText: 'Seats',
                                obscureText: false,
                                maxLength: 8,
                                exactLength: 8,
                                minLength: 1,
                                textInputType: TextInputType.number,
                                filteringTextInputFormatter:
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                check: false,
                                prefixIcon: Icons.chair_alt_outlined,
                                hideCheckMark: true),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                    SizedBox(
                      width: 300,
                      child: MyButton(
                        btnText: 'Predict',
                        onTap: predict,
                        backgroudColor: const Color.fromARGB(255, 255, 243, 23),
                        foregroudColor: const Color.fromARGB(255, 38, 38, 38),
                        icon: Icons.gamepad_outlined,
                      ),
                    ),
                    SizedBox(
                        child: Text(
                      result,
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 243, 23)),
                    )),
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
                            xValueMapper: (ChartDataPie data, _) =>
                                data.fuelType,
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
                              yValueMapper: (ChartDataBar data, _) =>
                                  data.counts,
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
                              yValueMapper: (ChartDataPie data, _) =>
                                  data.counts,
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
                            // Your legend configurations
                            ),
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
                          LineSeries<ChartDataScatterLine, double>(
                              dataSource:
                                  chartDataScatterLine, // Your data source
                              xValueMapper: (ChartDataScatterLine data, _) =>
                                  data.power,
                              yValueMapper: (ChartDataScatterLine data, _) =>
                                  1.7,
                              color: const Color.fromARGB(255, 9, 58, 255),
                              markerSettings: const MarkerSettings(
                                isVisible: true,
                              )),
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
                            color: Color.fromARGB(255, 255, 255,
                                255), // Change the label color here
                          ),
                          majorGridLines: const MajorGridLines(
                              color: Color.fromARGB(100, 255, 23, 124)),
                        ),
                      ),
                    ),
                  ],
                ),
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
