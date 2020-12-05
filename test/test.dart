
import 'package:train_api/main.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  
  test('test', () async {

    await TrainApi.getStationListTrains();
  });
}