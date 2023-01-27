import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:graphql/client.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_flutter_api/k2_flutter_util_repository.dart';
import 'package:k2_flutter_api/models/k2_my_attendance.dart';
import 'package:k2_staff/bloc/authentication/authentication_cubit.dart';
import 'package:k2_staff/core/services/service_locator.dart';

part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit({required this.authCubit}) : super(ScheduleState());

  final CoreApiService? coreApiService = app<K2CoreApiClient>();
  final DateFormat dateFormatter = new DateFormat('yyyy-MM-dd');
  final AuthenticationCubit authCubit;

  init() async {
    String staffId = authCubit.state.staffProfile!.id;

    K2DateTimeRange defaultToday = K2DateTimeRange(
        startTime: Jiffy().startOf(Units.MONTH).dateTime.toIso8601String(),
        endTime: Jiffy().endOf(Units.MONTH).dateTime.toIso8601String());

    final _response = (await coreApiService!.getMyAttendance(
        '', '', defaultToday.startTime!, defaultToday.endTime!,
        fetchPolicy: FetchPolicy.networkOnly));

    List<K2TimeEntry> _allTimeEntries = [];
    for (String? id in authCubit.state.centers.map((e) => e.id).toList()) {
      final _response = await _getTimeEntries(staffId, id!);
      _response.values.forEach((element) {
        _allTimeEntries.add(element!);
      });
    }

    List<K2TimeOffRequest> timeOffs = await _getMyTimeOffRequests(
        defaultToday.startTime!, defaultToday.endTime!);
    Map<DateTime, List<K2Shift>> shifts =
        await _getShiftsForPersonForDates(staffId, []..add(defaultToday));

    emit(state.copyWith(
        timeEntries: _allTimeEntries,
        timeOffs: timeOffs,
        shifts: shifts,
        attendance: _response.attendance,
        status: ScheduleStateStatus.initialized));
  }

  Future<List<K2TimeOffRequest>> _getMyTimeOffRequests(
      String startTime, String endTime) async {
    final _data = (await coreApiService!.getMyTimeOffRequests(
            startTime, endTime,
            fetchPolicy: FetchPolicy.cacheAndNetwork))!
        .data!;
    List<dynamic> timeOffs = _data['getMyTimeOffRequests'];
    List<K2TimeOffRequest> result = [];
    for (var timeOff in timeOffs) {
      result.add(K2TimeOffRequest.fromJson(timeOff));
    }
    return result;
  }

  Future<Map<String?, K2TimeEntry?>> _getTimeEntries(
      String personId, String centerId) async {
    final _now = this.dateFormatter.format(new DateTime.now().toUtc());
    Map<String?, K2TimeEntry?> _teMap = {};
    try {
      final _response = (await coreApiService!.getMyAttendance(
          personId, centerId, _now, _now,
          fetchPolicy: FetchPolicy.networkOnly));
      print(_response);
    } catch (_) {}
    return _teMap;
  }


  Future<Map<DateTime, List<K2Shift>>> _getShiftsForPersonForDates(
      String personId, List<K2DateTimeRange> dates) async {
    final _data =
        (await coreApiService!.getShiftsForPersonForDates(personId, dates))!
            .data!;
    List<dynamic> _shifts = _data['getShiftsForPersonForDates'];
//    _shifts.retainWhere((element) => element['centerId'] == centerId);
    Map<DateTime, List<K2Shift>> _result = {};
    for (var _shift in _shifts) {
      final _k2Shift = K2Shift.fromJson(_shift);

      DateTime fulldateTime = Jiffy(_k2Shift.startTime).dateTime;
      DateTime dt = DateUtils.dateOnly(fulldateTime);

      if (_result.containsKey(dt))
        _result[dt]!.add(_k2Shift);
      else {
        _result.putIfAbsent(dt, () => [_k2Shift]);
      }
    }
    return _result;
  }
}
