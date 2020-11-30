import 'package:flutter/widgets.dart';
import 'package:train_api/Classes/Station.dart';
import 'package:train_api/Classes/Train.dart';

///This is the class with the trip data
class Route {

  Station startStation;
  Station endStation;

  String duration;
  List<Train> trainList;

  Route({
    @required this.startStation,
    @required this.endStation,

    @required this.duration,
    @required this.trainList,
  });


  DateTime get startDateTime => trainList[0].startDate;
  DateTime get endDateTime => trainList.last.endDate;

}