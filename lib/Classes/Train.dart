import 'package:flutter/widgets.dart';
import 'package:train_api/Classes/Station.dart';

///The class that specify the train details
class Train {

  String startStationName;
  String arriveStationName;

  DateTime startDate;
  DateTime endDate;

  String category;
  String trainNumber;

  Train({
    @required this.startStationName,
    @required this.arriveStationName,

    @required this.startDate,
    @required this.endDate,

    @required this.category,
    @required this.trainNumber,
  });


  TrainDetails toTrainDetailsWithOtherData({
    @required int delay,
    @required String categoryDescr,
    @required List<StationDetails> detailedStationList
  }) => TrainDetails(
    startStationName: startStationName, 
    arriveStationName: arriveStationName,
    startDate: startDate,
    endDate: endDate,
    category: category,
    trainNumber: trainNumber,

    delay: delay,
    categoryDescr: categoryDescr,
    detailedStationList: detailedStationList,
  );

}


class TrainDetails extends Train {

  int delay;
  String categoryDescr;

  List<StationDetails> detailedStationList;

  TrainDetails({
    @required String startStationName,
    @required String arriveStationName,

    @required DateTime startDate,
    @required DateTime endDate,

    @required String category,
    @required String trainNumber,

    this.delay,
    this.categoryDescr,
    this.detailedStationList,

  }) : super(
    category: category,
    endDate: endDate,
    arriveStationName: arriveStationName,
    startDate: startDate,
    startStationName: startStationName,
    trainNumber: trainNumber,
  );

}