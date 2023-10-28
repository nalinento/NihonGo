import 'dart:math';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:nihon/DataBaseHelper.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';





class MyListView extends StatefulWidget {



  @override
  State<MyListView> createState() => _MyListViewState();

}

class _MyListViewState extends State<MyListView> with SingleTickerProviderStateMixin{
  //-----Animation Lottie-----------------------------------------------------/
  late AnimationController _controller;
  static String animation ="assets/quesition.json";
  bool anime = true;

  @override
  void initState() {
    super.initState();
    readCSV();
    // Create an AnimationController with a duration
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),

    );
    _controller.addStatusListener((status) async{
      if(status==AnimationStatus.completed){

        _controller.reset();
      }
    });
    // Create an animation using Tween

  }
  //-----------------------Load CSV File-----------------------
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
  static List<String> sinhalaCsv=[];
  static List<String> japanCsv=[];
  Future<void> saveSpecificDataToSQLite(List<dynamic> data) async {

    if (data != null && data.length >= 3) {

      for(int a =0; a<data.length; a++){
        sinhalaCsvS = data[a][1].toString();
        japanCsvS = data[a][2].toString();

        sinhalaCsv.add(sinhalaCsvS);
        japanCsv.add(japanCsvS);
      }
      save(sinhalaCsv, japanCsv);
    }
  }


  Future<void> save(List<String> sinhala,List<String> japan) async {
    final databaseHelp =DatabaseHelper.instance;
    String? list = await databaseHelp.findColumnValueById('User', 'japan', 1);
    List<String> sin =sinhala;
    List<String> jap = japan;

    if(list==null) {
      for (int a = 0; a < japanCsv.length; a++) {
        await databaseHelp.insertData(sin[a], jap[a]);
      }

    };
  }
  //-------------End CSV File------------------------
  void setAnime(bool anime){
    String str= anime? "assets/correct.json":"assets/wrong.json";
    setState(() {
      animation=str;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void playAnimation(bool animi) {
    if (!_controller.isAnimating) {
      setAnime(animi);
      _controller.forward();
    }
  }
  //---setSinhala Text--------------------------------------------------------/
  String name='බොනවා';
  String images ="";

  void setName(String st){
    setState(() {
      name=st;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
            child: Text('大切な　ことば',style: TextStyle(color: Colors.white,fontSize: 25))),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 400, // Set the desired height for the Container
            color: Colors.blue,
            alignment: Alignment.center,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.blue,
                    child: Center(

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            name,
                            style: TextStyle(color: Colors.white, fontSize: 20.0),
                          ),

                        ],

                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      child: Lottie.asset(
                          animation, // Replace with your Lottie animation file
                          width: 200,
                          height: 200,
                          animate: false,
                          controller: _controller,
                          onLoaded: (composition){

                          }
                      ),
                    ))
              ],
            ),
          ),
          HihonReorderableListView(onStringChange: setName,setAnime:playAnimation ,),
        ],
      ),
    );
  }
}
class HihonReorderableListView extends StatefulWidget {
  final Function(String) onStringChange;
  final Function(bool) setAnime;


  HihonReorderableListView({required  this.onStringChange,required this.setAnime});
  @override
  _HihonReorderableListViewState createState() =>
      _HihonReorderableListViewState();
}

class _HihonReorderableListViewState
    extends State<HihonReorderableListView> {

  _MyListViewState myListView = _MyListViewState();
//------Database initialisation
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findById();
    findSinhalaById();
    test();
  }
//----shuffele ReordableListView
  bool allowReorder = true;
  bool isTrue = false;
  static String? list =" ";
  final dbHelper = DatabaseHelper.instance;
  static int inCreament =1;
  static int isPosite =10;
  static int same = 0;
  void findById() async{

    if(inCreament<isPosite) {
      list = await dbHelper.findColumnValueById('User', 'japan', inCreament);
      test();
      if(inCreament==isPosite-1){
        if(same>=1){
          inCreament= inCreament-9;

          same=0;
        }
        if(same==0){
          isPosite=isPosite+9;
        }
      }

    }

  }
  static List<String> ac = ["のみます"];
  static List<String> abc =[];
  static List<String> items = [];

  static List<String> generate() {
    List<String> as = List.generate(abc.length, (index) => abc[index]);
    return as;
  }
  void test() async{
    ac = (list ?? "").split('');
    abc = shuffleList(ac);
    items = generate();
    checkWord(0, items.length-1);
  }
  static List<String> shuffleList<String>(List<String> inputList) {
    List<String> shuffledList = List.from(inputList);
    Random random = Random();
    for (int i = shuffledList.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      String temp = shuffledList[i];
      shuffledList[i] = shuffledList[j];
      shuffledList[j] = temp;
    }
    return shuffledList;
  }
  //--------Sinhala word for Textview------------
  static int increment =2;
  static String? firstSinhala="";
  static String lastWord =" ";
  void findSinhalaById() async{

    if(increment<isPosite) {
      firstSinhala =
      await dbHelper.findColumnValueById('User', 'sinhala', increment);
      changeSinhala();
      if(increment==isPosite-1){
        if(same>=1){
          increment= increment-9;
        }
      }
    }

  }
  void changeSinhala() async{

    lastWord = firstSinhala ?? "";
  }

  final play = AudioPlayer();

  void checkWord(int oldIndex, int newIndex) {

    Random rm =Random();

    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);

      bool testEntity = ListEquality().equals(ac, items);

      if (testEntity) {

      }
    });

  }
  @override
  Widget build(BuildContext context) {

    ;
    return Column(
      children: [
        Container(

          height: 100,
          // Set the desired height for the horizontal ReorderableListView
          child: ReorderableListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            onReorder: checkWord,

            itemBuilder: (context, index) {
              return Card(

                key: Key('$index'),
                margin: EdgeInsets.all(6.0),
                child: Container(
                  width: 40,
                  height: 20,
                  alignment: Alignment.center,
                  child: Text(
                    items[index],
                    style: TextStyle(fontSize: 18.0),

                  ),

                ),
              );
            },
          ),

        ),
        SizedBox(height: 50),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                child: ElevatedButton(onPressed: ()async {
                  bool testEnty = ListEquality().equals(ac, items);

                  Random rn =Random();
                  if(!testEnty) {

                    play.play(AssetSource('wrong.mp3'));
                    setState(() {
                      items.shuffle(rn);
                    });
                    widget.setAnime(false);
                    Vibration.vibrate(duration: 200);
                    same++;
                  }
                  if(testEnty){
                    inCreament++;
                    increment++;
                    findById();

                    findSinhalaById();

                    widget.onStringChange(lastWord);
                    widget.setAnime(true);
                    play.play(AssetSource('Congratulation.mp3'));
                  }
                },
                  child: Text("OK"),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      )
                  ),),
              )

            ],
          ),
        )
      ],
    );
  }

}
