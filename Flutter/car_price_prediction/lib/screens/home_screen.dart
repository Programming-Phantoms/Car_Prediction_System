import 'package:flutter/material.dart';
import 'chart_screen.dart';

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
          const SizedBox(height: 30),
          const Text(
            'Welcome to\nCar Price Prediction System',
            style: TextStyle(
                fontSize: 70,
                fontFamily: 'Main-Heading',
                color: Color.fromARGB(255, 255, 255, 255)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/car.png',
              width: 400,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Here you can predict the car price with more accuracy\nOur prediction modal is trained on 30 unique car brands',
            style: TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 255, 255, 255)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: changePage,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color.fromARGB(255, 255, 243, 23), // background color
              foregroundColor: const Color.fromARGB(255, 38, 38, 38),
              fixedSize: const Size(220, 40), // text color
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Start Prediction',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 15),
                Icon(Icons.gamepad_outlined)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
