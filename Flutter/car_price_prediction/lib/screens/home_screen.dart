import 'package:car_price_prediction/components/button.dart';
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
      physics: const BouncingScrollPhysics(),
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
          const SizedBox(height: 50),
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/logo.png',
              width: 200,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Here you can predict the car price with more accuracy',
            style: TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 255, 255, 255)),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Our prediction modal is trained on 30 unique car brands',
            style: TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 255, 255, 255)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          SizedBox(
              width: 300,
              child: MyButton(
                btnText: 'Start Prediction',
                onTap: changePage,
                backgroudColor: const Color.fromARGB(255, 255, 243, 23),
                foregroudColor: const Color.fromARGB(255, 38, 38, 38),
                icon: Icons.gamepad_outlined,
              ))
        ],
      ),
    );
  }
}
