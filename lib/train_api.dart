library train_api;

import 'package:http/http.dart' as http;
import 'package:train_api/Classes/ALL.dart';
import 'dart:convert';

import 'package:train_api/Data/CustomDateFormat/CustomDateFormat.dart';

class TrainApi {


  ///Returns stations whose name begins with the given string
  static Future<List<Station>> returnStations(String stationName) async {
    http.Response response = await http.get('http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/autocompletaStazione/$stationName');
    //Trenitalia: https://www.lefrecce.it/msite/api/solutions?origin=roma%20termini&destination=cesena&arflag=A&adate=30/01/2021&atime=08&adultno=1&childno=0&direction=A&frecce=false&onlyRegional=false

    List<Station> _stationList = [];

    for (String stringa in response.body.toString().split('\n')) {
      List<String> _stationInfo = stringa.toString().split('|');

      //This if is needed to avoid various errors
      if(_stationInfo.length == 2){
        _stationList.add(Station(
          name: _stationInfo[0].toString(),
          id: _stationInfo[1].toString(),
        ));
      }
    }

    print(_stationList);
    return _stationList;
  }


  static Future<List<Route>> returnRoutes(Station startStation, Station endStation, DateTime date) async {

    ///Get info from online server as Map (`json.decode(...)`)
    http.Response response = await http.get('http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/soluzioniViaggioNew/${startStation.idWithoutPrefix}/${endStation.idWithoutPrefix}/'
      + CustomDateFormat.stringFromDateTime(DateTime.now()));
    final body = json.decode(response.body);

    //This is the list that will be returned
    List<Route> _listRoutes = [];

    //For each travel solution, create a route
    List.from(body['soluzioni']).forEach((element) {

      //Create the train list (this has length == 1 if there are no train change)
      //
      //If the route provides a change, the list will have a length other than 1
      List<Train> _trainList = List.generate(
        List.from(element['vehicles']).length, 
        (index) => Train(
          startStationName: element['vehicles'][index]['origine'],
          endStationName: element['vehicles'][index]['destinazione'],
          startDate: CustomDateFormat.dateTimeFromString(element['vehicles'][index]['orarioPartenza'].toString()),
          endDate: CustomDateFormat.dateTimeFromString(element['vehicles'][index]['orarioArrivo'].toString()),
          category: element['vehicles'][index]['categoriaDescrizione'],
          trainNumber: element['vehicles'][index]['numeroTreno'],
        ));

      //Add this route to the main list that will be returned
      _listRoutes.add(Route(
        startStation: startStation, 
        endStation: endStation, 
        duration: element['durata'].toString(), 
        trainList: _trainList
      ));
    });

    return _listRoutes;
  }


  static Future<TrainDetails> getTrainDetails(Train train) async {

    //Get the station id (needed for next step)
    http.Response response = await http.get('http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/cercaNumeroTrenoTrenoAutocomplete/${train.trainNumber}');
    String idStazionePartenza = response.body.trim().split('-').last;

    //Get the effective train details
    http.Response trainDetailsRaw = await http.get('http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/andamentoTreno/$idStazionePartenza/${train.trainNumber}');

    try {
      Map trainDetails = json.decode(trainDetailsRaw.body);

      List<StationDetails> stationsDetails = List.generate(trainDetails['fermate'].length, (index) {
        Map _details = trainDetails['fermate'][index];

        return StationDetails(
          id: _details['id'],
          name: _details['stazione'],
          arrivoReale: DateTime.fromMicrosecondsSinceEpoch(int.parse(_details['arrivoReale'])),
          arrivoTeorico: DateTime.fromMicrosecondsSinceEpoch(int.parse(_details['arrivoTeorico'])),
          binarioEffettivoArrivoDescrizione: _details['binarioEffettivoArrivoDescrizione'],
          binarioEffettivoPartenzaDescrizione: _details['binarioEffettivoPartenzaDescrizione'],
          binarioProgrammatoArrivoDescrizione: _details['binarioProgrammatoArrivoDescrizione'],
          binarioProgrammatoPartenzaDescrizione: _details['binarioProgrammatoPartenzaDescrizione'],
          numeroStazioneDelTreno: _details['numeroStazioneDelTreno'],
          partenzaReale: _details['partenzaReale'],
          partenzaTeorica: _details['partenzaTeorica'],
          ritardoArrivo: _details['ritardoArrivo'],
          ritardoPartenza: _details['ritardoPartenza'],
        );
      });

      TrainDetails details = train.toTrainDetailsWithOtherData(
        delayMin: trainDetails['ritardo'],
        categoria: trainDetails['categoria'],
        categoriaDescr: trainDetails['compTipologiaTreno'],
        detailedStationList: stationsDetails,
      );

      return details;

    } catch (e) {
      print('Error during json.decode: most of the time this means that the train id does not match any real train.\nCheck the train ID');
      return null;
    }
  }

}