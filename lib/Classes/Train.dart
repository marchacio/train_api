import 'package:flutter/widgets.dart';

///The class that specify the train details
class Train {

  //TODO cerca di cambiare queste String in Station
  String startStation;
  String endStation;

  DateTime startDate;
  DateTime endDate;

  String category;
  String trainNumber;

  Train({
    @required this.startStation,
    @required this.endStation,

    @required this.startDate,
    @required this.endDate,

    @required this.category,
    @required this.trainNumber,
  });

}