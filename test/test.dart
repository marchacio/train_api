
import 'package:train_api/train_api.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  
  test('test', () async {

    await TrainApi.getArriveStationListTrains(null);
  });
}