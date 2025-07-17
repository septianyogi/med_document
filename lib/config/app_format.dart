import 'package:intl/intl.dart';

class AppFormat {
  // ignore: non_constant_identifier_names
  static String Date(String date){
    return DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(date));
  }
}