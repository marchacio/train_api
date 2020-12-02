
import 'package:flutter/cupertino.dart';

class Weather {

  String idStation;

  int todayTemp;
  int todayMorningTemp;
  int todayAfternoonTemp;
  int todayEveningTemp;
  int todayWeather;
  int todayMorningWeather;
  int todayAfternoonWeather;
  int todayEveningWeather;
  int tomorrowTemp;
  int tomorrowMorningTemp;
  int tomorrowAfternoonTemp;
  int tomorrowEveningTemp;
  int tomorrowWeather;
  int tomorrowMorningWeather;
  int tomorrowAfternoonWeather;
  int tomorrowEveningWeather;

  Weather({
    @required this.idStation,
    this.todayTemp,
    this.todayMorningTemp,
    this.todayAfternoonTemp,
    this.todayEveningTemp,
    this.todayWeather,
    this.todayMorningWeather,
    this.todayAfternoonWeather,
    this.todayEveningWeather,
    this.tomorrowTemp,
    this.tomorrowMorningTemp,
    this.tomorrowAfternoonTemp,
    this.tomorrowEveningTemp,
    this.tomorrowWeather,
    this.tomorrowMorningWeather,
    this.tomorrowAfternoonWeather,
    this.tomorrowEveningWeather,
  });


  static Weather fromMap(Map<String, dynamic> map) => Weather(
    idStation: map['codStazione'],
    todayTemp: map['oggiTemperatura'],
    todayMorningTemp: map['oggiTemperaturaMattino'],
    todayAfternoonTemp: map['oggiTemperaturaPomeriggio'],
    todayEveningTemp: map['oggiTemperaturaSera'],
    todayWeather: map['oggiTempo'],
    todayMorningWeather: map['oggiTempoMattino'],
    todayAfternoonWeather: map['oggiTempoPomeriggio'],
    todayEveningWeather: map['oggiTempoSera'],
    tomorrowTemp: map['domaniTemperatura'],
    tomorrowMorningTemp: map['domaniTemperaturaMattino'],
    tomorrowAfternoonTemp: map['domaniTemperaturaPomeriggio'],
    tomorrowEveningTemp: map['domaniTemperaturaSera'],
    tomorrowWeather: map['domaniTempo'],
    tomorrowMorningWeather: map['domaniTempoMattino'],
    tomorrowAfternoonWeather: map['domaniTempoPomeriggio'],
    tomorrowEveningWeather: map['domaniTempoSera'],
  );

}