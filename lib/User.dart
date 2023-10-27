
class User{
  final  int? id;
  final  String sinhala;
  final  String japan;


  User({this.id,required this.sinhala,required this.japan});

  User.fromJson(Map<String, dynamic> json):
        id= json['id'],
        sinhala= json['sinhala'],
        japan=json['japan'];


  Map<String,dynamic> toJson() => {
    'id':id,
    'sinhala':sinhala,
    'japan':japan
  };


}