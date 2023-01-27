import 'package:k2_flutter_api/models/enums/k2_clock_out_type.dart';

class K2LogSummaryItem {
  K2ClockOutType? type;
  String? title;
  String? time;
  String? trailingText;

  K2LogSummaryItem({this.type, this.title, this.time, this.trailingText});
}