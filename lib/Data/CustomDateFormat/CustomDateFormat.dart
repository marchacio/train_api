import 'package:intl/intl.dart';

class CustomDateFormat {

  static String stringFromDateTime(DateTime dateTime) 
    => DateFormat('yyyy-MM-ddThh:mm:ss').format(dateTime);

  static DateTime dateTimeFromString(String dateTimeString)
    => DateFormat('yyyy-MM-ddThh:mm:ss').parse(dateTimeString);

}