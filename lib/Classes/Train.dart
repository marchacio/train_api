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



///This is the class for trains departing from a station
///Normally used only by the `TrainApi.getDepartureStationListTrains()` method
class DepartureTrain {

  final String scheduledDepartureBinary;
  final String realDepartureBinary;
  final String delay;
  final String trainNumber;
  final String category;
  final String departureStationCode;
  final String arriveStationName;

  final bool leaved;
  final bool isInStation;

  final DateTime departureDate;


  DepartureTrain({
    @required this.delay,
    @required this.realDepartureBinary,
    @required this.scheduledDepartureBinary,
    @required this.trainNumber,
    @required this.category,
    @required this.departureStationCode,
    @required this.arriveStationName,

    @required this.leaved,
    @required this.isInStation,

    @required this.departureDate,
  });
  

  static DepartureTrain fromMap(Map map) => DepartureTrain(
    delay: map['ritardo'].toString(),
    departureDate: DateTime.fromMillisecondsSinceEpoch(map['orarioPartenza']),
    isInStation: map['inStazione'],
    realDepartureBinary: map['binarioEffettivoPartenzaDescrizione'].toString(),
    scheduledDepartureBinary: map['binarioProgrammatoPartenzaDescrizione'].toString(),
    leaved: !map['nonPartito'],
    trainNumber: map['numeroTreno'].toString(),
    category: map['categoria'].toString(),
    departureStationCode: map['codOrigine'].toString(),
    arriveStationName: map['destinazione'].toString(),
  );

}


///This is the class for trains arriving to a station
///Normally used only by the `TrainApi.getArriveStationListTrains()` method
class ArriveTrain {

  final String scheduledArriveBinary;
  final String realArriveBinary;
  final String delay;
  final String trainNumber;
  final String category;
  final String departureStationCode;
  final String departureStationName;

  final bool leaved;
  final bool isInStation;

  final DateTime arriveDate;


  ArriveTrain({
    @required this.delay,
    @required this.realArriveBinary,
    @required this.scheduledArriveBinary,
    @required this.trainNumber,
    @required this.category,
    @required this.departureStationCode,
    @required this.departureStationName,

    @required this.leaved,
    @required this.isInStation,

    @required this.arriveDate,
  });
  

  static ArriveTrain fromMap(Map map) => ArriveTrain(
    delay: map['ritardo'].toString(),
    arriveDate: DateTime.fromMillisecondsSinceEpoch(map['orarioArrivo']),
    isInStation: map['inStazione'],
    realArriveBinary: map['binarioEffettivoArrivoDescrizione'].toString(),
    scheduledArriveBinary: map['binarioProgrammatoArrivoDescrizione'].toString(),
    leaved: !map['nonPartito'],
    trainNumber: map['numeroTreno'].toString(),
    category: map['categoria'].toString(),
    departureStationCode: map['codOrigine'].toString(),
    departureStationName: map['origine'].toString(),
  );

}
