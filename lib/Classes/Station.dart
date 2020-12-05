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

  @override
  bool operator ==(other) => other.id == id && other.name == name;

  @override
  int get hashCode => super.hashCode;

}


class StationDetails extends Station {

  DateTime scheduledDeparture;
  DateTime scheduledArrive;

  DateTime realDeparture;
  DateTime realArrive;

  int delayDeparture;
  int delayArrive;

  int stationNumberOfTrainRoute; //Es: la prima = 1, la seconda = 2...

  String arrivalScheduledBinary;
  String arrivalRealBinary;
  String departureScheduledBinary;
  String departureRealBinary;

  StationDetails({
    @required String id,
    @required String name,

    this.scheduledArrive,
    this.scheduledDeparture,
    this.realDeparture,
    this.realArrive,

    this.delayDeparture,
    this.delayArrive,

    this.stationNumberOfTrainRoute,
    
    this.arrivalScheduledBinary,
    this.arrivalRealBinary,
    this.departureScheduledBinary,
    this.departureRealBinary,

  }) : super(
    id: id,
    name: name,
  );

}