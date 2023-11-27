import 'package:flutter/material.dart';

import 'chart.dart';

class Home extends StatefulWidget {
  static String routeName = '/home-page';
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  void changePage() {
    Navigator.pushNamed(context, Charts.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50),
          Text(
            'Welcome to Car Price Prediction System',
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/car.png',
              width: 500,
            ),
          ),
          SizedBox(height: 50),
          ElevatedButton(
            onPressed: changePage,
            style: ElevatedButton.styleFrom(
              primary: Colors.black, // background color
              onPrimary: Colors.white,
              fixedSize: Size(400, 60), // text color
            ),
            child: Text(
              'Start Prediction',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
