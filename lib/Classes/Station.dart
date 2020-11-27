import 'package:flutter/widgets.dart';

///This is the station class
class Station {

  String name;
  String id;

  Station({
    @required this.name,
    @required this.id,
  });


  String get idWithoutPrefix => id.substring(2);

  @override
  String toString() => "$name,$id";  
}