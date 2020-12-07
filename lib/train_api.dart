library train_api;

export 'Classes/ALL.dart';


import 'Classes/ALL.dart';
import 'Data/CustomDateFormat/CustomDateFormat.dart';

import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


class TrainApi {

  ///Returns stations whose name begins with the given string
  static Future<List<Station>> getStations(String stationName) async {
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


  ///Return a `List<Route>` with the possibile travels for the user
  static Future<List<Route>> getRoutes(Station startStation, Station endStation, DateTime date) async {

    ///Get info from online server as Map (`json.decode(...)`)
    http.Response response = await http.get('http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/soluzioniViaggioNew/${startStation.idWithoutPrefix}/${endStation.idWithoutPrefix}/'
      + CustomDateFormat.stringFromDateTime(date));
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
          arriveStationName: element['vehicles'][index]['destinazione'],
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


  ///Return details about a specific train
  ///
  ///Require a `Train` object to get details (get the `Train` object with:
  ///
  ///```
  ///List<Route> list = await TrainApi.getRoutes(...);
  ///for(Route _route in list) {
  ///   _route.trainList //====> this is a list of Train objects
  ///}
  ///``` 
  ///
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
          realArrive: (_details['arrivoReale'] != null) ? DateTime.fromMicrosecondsSinceEpoch(_details['arrivoReale']) : null,
          scheduledArrive: (_details['arrivoTeorico'] != null) ? DateTime.fromMicrosecondsSinceEpoch(_details['arrivoTeorico']) : null,
          arrivalRealBinary: _details['binarioEffettivoArrivoDescrizione'],
          departureRealBinary: _details['binarioEffettivoPartenzaDescrizione'],
          arrivalScheduledBinary: _details['binarioProgrammatoArrivoDescrizione'],
          departureScheduledBinary: _details['binarioProgrammatoPartenzaDescrizione'],
          stationNumberOfTrainRoute: _details['numeroStazioneDelTreno'],
          realDeparture: (_details['partenzaReale'] != null) ? DateTime.fromMicrosecondsSinceEpoch(_details['partenzaReale']) : null,
          scheduledDeparture:(_details['partenzaTeorica'] != null) ? DateTime.fromMicrosecondsSinceEpoch(_details['partenzaTeorica']) : null,
          delayArrive: _details['ritardoArrivo'],
          delayDeparture: _details['ritardoPartenza'],
        );
      });

      TrainDetails details = train.toTrainDetailsWithOtherData(
        delay: trainDetails['ritardo'],
        categoryDescr: trainDetails['compTipologiaTreno'],
        detailedStationList: stationsDetails,
      );

      return details;

    } catch (e) {
      print(e);
      print('Error during json.decode: most of the time this means that the train id does not match any real train.\nCheck the train ID');
      return null;
    }
  }


  ///Return a `List<Weather>` with all weather informations of the most important italian stations
  ///(ex: *Roma Termini*, *Torino Porta Nuova*, *Napoli Centrale*, *Milano Centrale*, *Genova Piazza Principe* and more...)
  static Future<List<Weather>> getWeatherInfo() async {

    http.Response response = await http.get('http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/datimeteo/0');

    Map<String, dynamic> body = json.decode(response.body);

    List<Weather> weatherList = List<Weather>.generate(body.keys.length, (index) => Weather.fromMap(body[body.keys.toList()[index]]));

    return weatherList;
  }

  ///Return a link to display weather images
  ///
  ///EX:
  /// * Cloudly: http://www.viaggiatreno.it/vt_static/img/legenda/meteo/108.png  ![](http://www.viaggiatreno.it/vt_static/img/legenda/meteo/108.png)
  /// * Heavy rain: http://www.viaggiatreno.it/vt_static/img/legenda/meteo/113.png  ![](http://www.viaggiatreno.it/vt_static/img/legenda/meteo/113.png)
  /// * Night light cloudly: http://www.viaggiatreno.it/vt_static/img/legenda/meteo/103.png  ![](http://www.viaggiatreno.it/vt_static/img/legenda/meteo/103.png)
  static String getMeteoImageLinkFromInt(int _int) => 'http://www.viaggiatreno.it/vt_static/img/legenda/meteo/$_int.png';


  ///Get a list of `DepartureTrain`.
  ///
  ///`DepartureTrain` is the class that contains all the data of trains departing from the given `station`
  static Future<List<DepartureTrain>> getDepartureStationListTrains(Station station) async {

    String url = 'http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/partenze/${station.id}/'
     + DateFormat('EEE').format(DateTime.now()) + '%20' 
     + DateFormat('MMM').format(DateTime.now()) + '%20' 
     + DateFormat('dd').format(DateTime.now()) + '%20' 
     + DateFormat('yyyy').format(DateTime.now()) + '%20'
     + DateFormat('HH:mm:ss').format(DateTime.now());
    http.Response response = await http.get(url);

    List body = json.decode(response.body);

    List<DepartureTrain> _list = List.generate(body.length, (index) => DepartureTrain.fromMap(body[index]));

    return _list;
  }



  static Future<List<ArriveTrain>> getArriveStationListTrains(Station station) async {

    String url = 'http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/arrivi/S04702/'
     + DateFormat('EEE').format(DateTime.now()) + '%20' 
     + DateFormat('MMM').format(DateTime.now()) + '%20' 
     + DateFormat('dd').format(DateTime.now()) + '%20' 
     + DateFormat('yyyy').format(DateTime.now()) + '%20'
     + DateFormat('HH:mm:ss').format(DateTime.now());
    http.Response response = await http.get(url);

    List body = json.decode(response.body);

    List<ArriveTrain> _list = List.generate(body.length, (index) => ArriveTrain.fromMap(body[index]));

    return _list;
  }
}