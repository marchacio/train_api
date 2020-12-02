
import 'package:train_api/main.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  
  test('info meteo', () async {

    await TrainApi.getMeteoInfo();
  });
}