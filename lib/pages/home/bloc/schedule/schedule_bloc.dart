// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:graphql/client.dart';
// import 'package:intl/intl.dart';
// import 'package:jiffy/jiffy.dart';
// import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
// import 'package:k2_flutter_api/k2_flutter_util_repository.dart';
// import 'package:k2_staff/core/services/service_locator.dart';


// import 'schedule_event.dart';
// import 'schedule_state.dart';

// class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
//   ScheduleBloc() : super(ScheduleInitial());

//   final AuthService authService = app<CognitoService>();
//   final CoreApiService? coreApiService = app<K2CoreApiClient>();
//   final DateFormat dateFormatter = new DateFormat('yyyy-MM-dd');

//   Future<Map<String?, K2TimeEntry?>> _getTimeEntries(
//       String personId, String centerId) async {
//     final _now = this.dateFormatter.format(new DateTime.now().toUtc());
//     Map<String?, K2TimeEntry?> _teMap = {};
//     try {
//     final _response = (await coreApiService!
//         .getMyAttendance(personId, centerId, _now, _now,
//             fetchPolicy: FetchPolicy.networkOnly));
//             print(_response);
//     // _teMap = Map.fromIterable(
//     //     _response.attendance.days,
//     //     key: (e) => e.id,
//     //     value: (e) => e);
//     }
//     catch (_) {
//     }
//     return _teMap;
//   }

//   Future<Map<String?, K2Shift>> _getShiftsForPersonForDates(
//       String personId, List<K2DateTimeRange> dates, String centerId) async {
//     final _data = (await coreApiService!
//             .getShiftsForPersonForDates(personId, dates))!
//         .data!;
//     List<dynamic> _shifts = _data['getShiftsForPersonForDates'];
//     _shifts.retainWhere((element) => element['centerId'] == centerId);
//     Map<String?, K2Shift> _result = new Map();
//     for (var _shift in _shifts) {
//       final _k2Shift = K2Shift.fromJson(_shift);
//       _result[_k2Shift.id] = _k2Shift;
//     }
//     return _result;
//   }

//   Future<List<K2Shift>> _getAllShiftsForPersonForDates(
//       String personId, List<K2DateTimeRange> dates) async {
//     final _data = (await coreApiService!
//             .getShiftsForPersonForDates(personId, dates,
//                 fetchPolicy: FetchPolicy.cacheAndNetwork));
//                // !
//      //   .data!;
//     List<dynamic> shifts = _data!.data!['getShiftsForPersonForDates'];
//     List<K2Shift> result = [];
//     for (var shift in shifts) {
//       final k2Shift = K2Shift.fromJson(shift);
//       result.add(k2Shift);
//     }
//     return result;
//   }

//   Future<List<K2TimeOffRequest>> _getMyTimeOffRequests(
//       String startTime, String endTime) async {
//     final _data = (await coreApiService!
//             .getMyTimeOffRequests(startTime, endTime,
//                 fetchPolicy: FetchPolicy.cacheAndNetwork))!
//         .data!;
//     List<dynamic> timeOffs = _data['getMyTimeOffRequests'];
//     List<K2TimeOffRequest> result = [];
//     for (var timeOff in timeOffs) {
//       result.add(K2TimeOffRequest.fromJson(timeOff));
//     }
//     return result;
//   }

//   void _onEvent(ScheduleEvent event, Emitter<ScheduleState> emit) {
//     if (event is ScheduleEventInitial) return _onScheduleEventInitialization(event, emit);
//     if (event is FetchMyTimeOffsEvent) return _onFetchMyTimeOffs(event, emit);;
//     if (event is ScheduleUpdateDateRangeEvent) return _onScheduleUpdateDateRange(event, emit);;
//   //  if (event is ScheduleUpdateDateRangeEvent) return _onScheduleEventInitialization(event, emit);;
//   }

//   void _onScheduleEventInitialization(
//     ScheduleEventInitial event,
//     Emitter<ScheduleState> emit,
//   ) async {

//  K2DateTimeRange defaultToday = K2DateTimeRange(
//               startTime: Jiffy().startOf(Units.DAY).dateTime.toIso8601String(),
//               endTime: Jiffy().endOf(Units.DAY).dateTime.toIso8601String());

          
//           // K2User? k2user = await (authService
//           //     .authActionGetCurrentUser());
          
//           // if (k2user == null) {
//           //   //TODO fix null safety check
//           //   return;
//           // }

//           String? personId = (event as ScheduleEventInitial).k2staffProfile!.id;

//           List<K2Center> _centers = await coreApiService!
//               .getAllowedEntities(fetchPolicy: FetchPolicy.networkOnly)
//               .then((value) => value.entities
//                   .map((e) => e.centers)
//                   .expand((element) => element!)
//                   .toList());
//           List<K2TimeEntry?> _allTimeEntries = [];
//           for (String? id in _centers.map((e) => e.id).toList()) {
//             final _response = await _getTimeEntries(personId, id!);
//             _response.values.forEach((element) {
//               _allTimeEntries.add(element);
//             });
//           }

//           List<K2TimeOffRequest> timeOffs = await _getMyTimeOffRequests(
//               new Jiffy().startOf(Units.WEEK).dateTime.toIso8601String(),
//               new Jiffy().endOf(Units.WEEK).dateTime.toIso8601String());

//       emit(SelectedScheduleState(defaultToday, _allTimeEntries,
//               myTimeOffs: timeOffs));
//   }

//   void _onFetchMyTimeOffs(
//     FetchMyTimeOffsEvent event,
//     Emitter<ScheduleState> emit,
//   ) async {
//            List<K2TimeOffRequest> timeOffs = await _getMyTimeOffRequests(
//             new Jiffy().startOf(Units.WEEK).dateTime.toIso8601String(),
//             new Jiffy().endOf(Units.WEEK).dateTime.toIso8601String());
//         yield (state as SelectedScheduleState).updateWith(myTimeOffs: timeOffs);
//       emit(SelectedScheduleState.updateWith(myTimeOffs: timeOffs));
//   }

//   void _onScheduleUpdateDateRange(
//     ScheduleUpdateDateRangeEvent event,
//     Emitter<ScheduleState> emit,
//   ) async {
//       emit(ScheduleUpdateDateRangeEvent(childSession: event.childSession));
//       emit(ChildStateChangeFinished());
//   }

//   @override
//   Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
//     switch (event.runtimeType) {
//       case ScheduleEventInitial:
//         {
//           // Probably default to this week?
//           K2DateTimeRange defaultToday = K2DateTimeRange(
//               startTime: Jiffy().startOf(Units.DAY).dateTime.toIso8601String(),
//               endTime: Jiffy().endOf(Units.DAY).dateTime.toIso8601String());

          
//           // K2User? k2user = await (authService
//           //     .authActionGetCurrentUser());
          
//           // if (k2user == null) {
//           //   //TODO fix null safety check
//           //   return;
//           // }

//           String? personId = (event as ScheduleEventInitial).k2staffProfile!.id;

//           List<K2Center> _centers = await coreApiService!
//               .getAllowedEntities(fetchPolicy: FetchPolicy.networkOnly)
//               .then((value) => value.entities
//                   .map((e) => e.centers)
//                   .expand((element) => element!)
//                   .toList());
//           List<K2TimeEntry?> _allTimeEntries = [];
//           for (String? id in _centers.map((e) => e.id).toList()) {
//             final _response = await _getTimeEntries(personId, id!);
//             _response.values.forEach((element) {
//               _allTimeEntries.add(element);
//             });
//           }

//           List<K2TimeOffRequest> timeOffs = await _getMyTimeOffRequests(
//               new Jiffy().startOf(Units.WEEK).dateTime.toIso8601String(),
//               new Jiffy().endOf(Units.WEEK).dateTime.toIso8601String());

//           yield SelectedScheduleState(defaultToday, _allTimeEntries,
//               myTimeOffs: timeOffs);
//           break;
//         }
//       case FetchMyTimeOffsEvent:
//         List<K2TimeOffRequest> timeOffs = await _getMyTimeOffRequests(
//             new Jiffy().startOf(Units.WEEK).dateTime.toIso8601String(),
//             new Jiffy().endOf(Units.WEEK).dateTime.toIso8601String());
//         yield (state as SelectedScheduleState).updateWith(myTimeOffs: timeOffs);
//         break;
//       case ScheduleUpdateDateRangeEvent:
//         String k2UserId = (await ((event as ScheduleUpdateDateRangeEvent)
//             .k2user!
//             .getPersonId()));
//         List<K2DateTimeRange>? dates;
//         if (event.dates != null) {
//           dates = event.dates;
//         } else {
//           dates = [
//             new K2DateTimeRange(
//                 startTime: Jiffy()
//                     .startOf(Units.WEEK)
//                     .subtract(duration: Duration(days: 7))
//                     .dateTime
//                     .toIso8601String(),
//                 endTime: Jiffy()
//                     .endOf(Units.WEEK)
//                     .add(duration: Duration(days: 7))
//                     .dateTime
//                     .toIso8601String())
//           ];
//         }
//         List<K2Shift> shiftSchedule =
//             await _getAllShiftsForPersonForDates(k2UserId, dates!);
//         yield (state as SelectedScheduleState).updateWith(
//             activeDateRange: dates.first, shiftSchedule: shiftSchedule);
//         break;
//       // print(shiftSchedule);
//     }
//   }
// }
