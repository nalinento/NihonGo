import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nihon/DataBaseHelper.dart';
import 'dart:async';

import 'package:nihon/Second.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatefulWidget {


  static List<String> sinhalaCsv=[];
  static List<String> japanCsv=[];

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState(){
    readCSV();
    super.initState();
  }
  Future<List<List<dynamic>>?> readCSV() async {
    try {

      String csvData = await rootBundle.loadString('assets/Datas.csv');
      final List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);
      saveSpecificDataToSQLite(csvTable);
      return csvTable;

    } catch (e) {
      print("Error reading CSV: $e");
      return null;
    }
  }

  String sinhalaCsvS="";

  String japanCsvS="";

  Future<void> saveSpecificDataToSQLite(List<dynamic> data) async {

    if (data != null && data.length >= 3) {

      for(int a =0; a<data.length; a++){
        sinhalaCsvS = data[a][1].toString();
        japanCsvS = data[a][2].toString();

        MyApp.sinhalaCsv.add(sinhalaCsvS);
        MyApp.japanCsv.add(japanCsvS);
      }
      save(MyApp.sinhalaCsv, MyApp.japanCsv);
    }
  }

  Future<void> save(List<String> sinhala,List<String> japan) async {
    final databaseHelp =DatabaseHelper.instance;
    String? list = await databaseHelp.findColumnValueById('User', 'japan', 1);

    List<String> sin =sinhala;
    List<String> jap = japan;
    print(list);


    if(list==null) {
      for (int a = 0; a < MyApp.japanCsv.length; a++) {
        await databaseHelp.insertData(sin[a], jap[a]);
      }

    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(), // Start with the SplashScreen widget
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // After 4 seconds, navigate to the MainPage
    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainPanel(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/Splash.png'), // Load your splash screen image
      ),
    );
  }
}

