import 'package:collection/collection.dart';
import 'package:graphql/client.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:k2_flutter_api/api/core_api_service.dart';
import 'package:k2_flutter_api/api/k2_core_api_client.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_staff/core/error_handlers.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/pages/home/v2/k2_summary_time_item.dart';
import 'package:k2_staff/pages/home/time_clock/k2_log_summary_item.dart';


mixin StaffTimeEntryHelpers {
  final DateFormat dateFormatter = new DateFormat('yyyy-MM-dd');
  final CoreApiService? coreApiService = app<K2CoreApiClient>();

  Future<Map<String?, K2TimeEntry>> getTimeEntries(
      String personId, String centerId) async {
    Map<String?, K2TimeEntry> _timeEntryMap = new Map();

    final _now = this.dateFormatter.format(new DateTime.now().toUtc());

     final _response = (await coreApiService!
        .getMyAttendance(personId, centerId, _now, _now,
            fetchPolicy: FetchPolicy.networkOnly));
            print(_response);
//     _timeEntryMap = await coreApiService!
//         .getTimeEntriesForPersonAtCenter(personId, centerId, _now, _now,
//             fetchPolicy: FetchPolicy.networkOnly)
//         .then((qr) {
// //          List<dynamic> _positions = _data['getStaff']['positions'];
//       List<K2TimeEntry> _timeEntries = qr.timeEntries;
//       _timeEntries.forEach((element) {
//         _timeEntryMap[element.id] = element;
//       });
//       return _timeEntryMap;
//     }).catchError(apiErrorHandler);
    return _timeEntryMap;
  }

  List<K2TimeEntrySummaryItem> getTimeEntrySummaryList(Map<String?, K2TimeEntry> timeEntries) {

    
    List<K2TimeEntrySummaryItem> summaryEntries = [];
    timeEntries.forEach((k,entry) {
      K2TimeEntrySummaryItem inEntry = K2TimeEntrySummaryItem(
        type: 'Clocked In', 
        time: entry.timeIn,
        position: entry.staffPosition?.title ?? ''
      );

      summaryEntries.add(inEntry);

      if (null != entry.timeOut) {
        K2TimeEntrySummaryItem outEntry = K2TimeEntrySummaryItem(
          type: 'Clocked Out', 
          time: entry.timeOut,
          position: entry.staffPosition?.title ?? ''
        );

        summaryEntries.add(outEntry);        
      }
     });
    
    return summaryEntries;
  }  

  List<K2LogSummaryItem> getLogSummaryItems(List<K2TimeEntry> timeEntries) {
    List<K2LogSummaryItem> logEntries = [];

    Map<String?, List<K2TimeEntry>> mappedTimeEntries =
        groupBy(timeEntries, (obj) => obj.positionId);
    mappedTimeEntries.forEach((key, value) {
      value.sort((a, b) =>
          Jiffy(a.timeIn).dateTime.compareTo(Jiffy(b.timeIn).dateTime));
      value.asMap().forEach((index, entry) {
        if (index == 0) {
          logEntries.add(K2LogSummaryItem(
              title: "Clock In",
              type: K2ClockOutType.ClockIn,
              time: entry.timeIn));
        } else if (entry.type == "BREAK") {
          logEntries.add(K2LogSummaryItem(
              title: "Clock out for break",
              type: K2ClockOutType.StartBreak,
              time: entry.timeIn,
              trailingText: entry.timeOut != null
                  ? "${Jiffy(entry.timeOut).diff(Jiffy(entry.timeIn), Units.MINUTE)}m"
                  : null));
          if (entry.timeOut != null) {
            logEntries.add(K2LogSummaryItem(
                title: "Clock in for break",
                type: K2ClockOutType.EndBreak,
                time: entry.timeOut));
          }
        } else if (entry.timeOut != null && (index == timeEntries.length - 1)) {
          logEntries.add(K2LogSummaryItem(
              title: "Clock Out",
              type: K2ClockOutType.ClockOut,
              time: entry.timeOut));
        }
      });
    });
    return logEntries;
  }
}

