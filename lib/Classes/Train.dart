import 'package:flutter/widgets.dart';
import 'package:train_api/Classes/Station.dart';

///The class that specify the train details
class Train {

  String startStationName;
  String endStationName;

  DateTime startDate;
  DateTime endDate;

  String category;
  String trainNumber;

  Train({
    @required this.startStationName,
    @required this.endStationName,

    @required this.startDate,
    @required this.endDate,

    @required this.category,
    @required this.trainNumber,
  });


  TrainDetails toTrainDetailsWithOtherData({
    @required int delayMin,
    @required String categoria,
    @required String categoriaDescr,
    @required List<StationDetails> detailedStationList
  }) => TrainDetails(
    startStationName: startStationName, 
    endStationName: endStationName,
    startDate: startDate,
    endDate: endDate,
    category: category,
    trainNumber: trainNumber,

    delayMin: delayMin,
    categoria: categoria,
    categoriaDescr: categoriaDescr,
    detailedStationList: detailedStationList,
  );

}


class TrainDetails extends Train {

  int delayMin;
  String categoria, categoriaDescr;

  List<StationDetails> detailedStationList;

  TrainDetails({
    @required String startStationName,
    @required String endStationName,

    @required DateTime startDate,
    @required DateTime endDate,

    @required String category,
    @required String trainNumber,

    this.delayMin,
    this.categoria,
    this.categoriaDescr,
    this.detailedStationList,

  }) : super(
    category: category,
    endDate: endDate,
    endStationName: endStationName,
    startDate: startDate,
    startStationName: startStationName,
    trainNumber: trainNumber,
  );

}