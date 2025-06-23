import 'package:intl/intl.dart';

class AppFormat {
  static String Date(String date){
    return DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(date!));
  }
}