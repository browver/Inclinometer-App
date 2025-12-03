import 'package:deviation_calculator/calc_page.dart';
import 'package:deviation_calculator/calculator_functions/local_data.dart';
// import 'package:deviation_calculator/calculator_functions/local_data.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize hive
  await Hive.initFlutter();

  // open a box
  await Hive.openBox("inclinometer_data");

  LocalData().addData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Deviation Calculator',
      home: CalcPage(),
    );
  }
}