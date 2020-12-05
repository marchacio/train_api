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

  DateTime partenzaTeorica;
  DateTime arrivoTeorico;

  DateTime partenzaReale;
  DateTime arrivoReale;

  int ritardoPartenza;
  int ritardoArrivo;

  int numeroStazioneDelTreno; //Es: la prima = 1, la seconda = 2...

  String binarioProgrammatoArrivoDescrizione;
  String binarioEffettivoArrivoDescrizione;
  String binarioEffettivoPartenzaDescrizione;
  String binarioProgrammatoPartenzaDescrizione;

  StationDetails({
    @required String id,
    @required String name,

    this.partenzaTeorica,
    this.arrivoTeorico,
    this.partenzaReale,
    this.arrivoReale,

    this.ritardoPartenza,
    this.ritardoArrivo,

    this.numeroStazioneDelTreno,
    
    this.binarioProgrammatoArrivoDescrizione,
    this.binarioEffettivoArrivoDescrizione,
    this.binarioEffettivoPartenzaDescrizione,
    this.binarioProgrammatoPartenzaDescrizione,

  }) : super(
    id: id,
    name: name,
  );

}