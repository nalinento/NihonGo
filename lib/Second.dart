import 'package:flutter/material.dart';
import 'package:nihon/DataEnter.dart';
import 'package:nihon/MyListView.dart';
import 'package:flutter/foundation.dart';

class MainPanel extends StatelessWidget {
  const MainPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nihon Dream',
      home: MainPage(),
    );
  }
}
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    Color customColor = Color.fromRGBO(2, 52, 247, 0.8);
    return Scaffold(
      backgroundColor: customColor,
      appBar: AppBar(
        title: Center(
          child: Text("ジャパニーズ・ドリーム"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(

                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(30.0)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),

                  ),

                ),
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> DataEntryPage()));
                }, child: Text("ADD DATA",style: TextStyle(fontSize: 16),),),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(30.0)),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  onPressed:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> MyListView()));
                  },
                  child: Text("      GAME    "))
            ],
          ),
        )
      ),
    );
  }
}

