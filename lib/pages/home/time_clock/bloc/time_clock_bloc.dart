import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:k2_flutter_api/api/core_api_service.dart';
import 'package:k2_flutter_api/api/k2_core_api_client.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_staff/core/error_handlers.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/pages/home/v2/k2_summary_time_item.dart';
import 'package:k2_staff/pages/home/time_clock/clock_in/staff_time_entry_mixin.dart';
import 'package:k2_staff/pages/home/time_clock/k2_log_summary_item.dart';
part 'time_clock_event.dart';
part 'time_clock_state.dart';

class TimeClockBloc extends Bloc<TimeClockEvent, TimeClockState> with StaffTimeEntryHelpers {
  TimeClockBloc({required this.employee, 
  required this.centerId, required this.timeStamp})
      : super(TimeClockStateInitial());

  final K2StaffProfile employee;
//  final DeepLinkCubit deepLinkCubit;
  final String centerId;
  final int timeStamp;
  final CoreApiService? coreApiService = app<K2CoreApiClient>();
  final DateFormat dateFormatter = new DateFormat('yyyy-MM-dd');

  Future<List<K2Position>> _getPositionsForPerson(String id) async {
    List<K2Position> positions =[];
    positions = await coreApiService!.getPositionsForPerson(id).then((qr) {
      List<K2Position> _positionsForCenter = [];
      List<dynamic> _positions = qr!.data!['getStaff']['positions'];
      for (var _p in _positions) {
        if (_p['scopeType'] == 'CENTER' && _p['scopeId'] != this.centerId)
          continue;
       _positionsForCenter.add(K2Position(id: _p['id'], title: _p['title']));
      }
      return _positionsForCenter;
    }).catchError(apiErrorHandler);
    return positions;
  }

  Future<Map<String?, K2Shift>> _getShiftsForStaffMemberForDates(
      String personId, List<K2DateTimeRange> dates, String? centerId) async {
    Map<String?, K2Shift> _result = new Map();
    _result = await coreApiService!
        .getShiftsForPersonForDates(personId, dates)
        .then((qr) {
      List<dynamic> _shifts = qr!.data!['getShiftsForPersonForDates'];
      _shifts.retainWhere((element) => element['centerId'] == centerId);
      for (var _shift in _shifts) {
        final _k2Shift = K2Shift.fromJson(_shift);
        _result[_k2Shift.id] = _k2Shift;
      }
      return _result;
    }).catchError(apiErrorHandler);
    return _result;
  }

  @override
  Stream<TimeClockState> mapEventToState(
    TimeClockEvent event,
  ) async* {
    if (event is TimeClockEventScanReceived) {
      // if (!this.deepLinkCubit.state.isAuthenticated!) {
      //   QR.navigator.replaceAll('/login');
      // }

      DateTime now = DateTime.now();
      DateTime timeClockTime = DateTime.fromMillisecondsSinceEpoch(
          this.timeStamp);
      Duration diff = now.difference(timeClockTime);

      if (diff.inSeconds > 60) yield TimeClockStateTimedOut();

      K2Shift? _selectedShift;

      List<K2DateTimeRange> _dates = [
        new K2DateTimeRange(
            startTime:
                new Jiffy().startOf(Units.DAY).dateTime.toIso8601String(),
            endTime: new Jiffy().endOf(Units.DAY).dateTime.toIso8601String())
      ];

      //TODO Does this person have access to the given center??

      final Map<String?, K2Shift> _shiftOptions =
          await _getShiftsForStaffMemberForDates(
              this.employee.id, _dates, this.centerId);

    // We need to determine if we should clock in or out...
    final _currentTimeEntries =
        await getTimeEntries(this.employee.id, this.centerId);  


    final K2TimeEntry? _openEntry = _currentTimeEntries.values
        .firstWhereOrNull((element) => element.timeOut == null);                    
    

    bool _hasOpenTimeEntry = _openEntry != null;
    if (_hasOpenTimeEntry) {
      // If the employee has an open time entry, they need to "resume"
      // Clock INTO a break
      // Clock BACK INTO their
      // Clock OUT
      _selectedShift = _shiftOptions[_openEntry.shiftId] ?? null;

      // QR.params['employee'] = this.employee;
      // QR.params['employee']!.keepAlive = true;

      // QR.params['openTimeEntry'] = _openEntry;
      // QR.params['openTimeEntry']!.keepAlive = true;

      // QR.params['shift'] = _shiftOptions[_openEntry.shiftId]!;
      // QR.params['shift']!.keepAlive = true;

      // QR.params['logEntries'] = getLogSummaryItems(
      //     _currentTimeEntries.entries.map((v) => (v.value)).toList());
      // QR.params['logEntries']!.keepAlive = true;

      // QR.params['selectedShift'] = _selectedShift!;
      // QR.params['selectedShift']!.keepAlive = true;

      // QR.navigator.replaceAll('/home/clockout');
      yield TimeClockStateClockingOut(
        openTimeEntry: _openEntry, 
        selectedShift:_selectedShift, 
        shift: _shiftOptions[_openEntry.shiftId] ?? null, 
        timeEntries: getTimeEntrySummaryList(_currentTimeEntries));
    
    } else {
      // We only want the employee to be able to clock into their *next* shift,
      // i.e. if they have an 8-11:30 and a 1-5:00, only show the 8-11:30
      // ADDITIONALLY, if they've already clocked into the 8-11:30, don't show it to them again.

      final Set<String?> _timeEntryShiftIds =
          _currentTimeEntries.values.map((e) => e.shiftId).toSet();
      _timeEntryShiftIds.removeWhere((element) => element == null);

      final Map<String?, K2Shift> _filteredOptions = _shiftOptions;
      _filteredOptions
          .removeWhere((key, value) => _timeEntryShiftIds.contains(value.id));

      var _nextShift;
      if (_filteredOptions.length > 1) {
        _nextShift = _filteredOptions.values.reduce((current, next) =>
            DateTime.parse(current.startTime!).millisecondsSinceEpoch <
                    DateTime.parse(next.startTime!).millisecondsSinceEpoch
                ? current
                : next);
      } else {
        _nextShift =
            _filteredOptions.isNotEmpty ? _filteredOptions.values.first : null;
      }
      _selectedShift = null;

      final _positions = await _getPositionsForPerson(this.employee.id);
      
      List<K2Shift> schedule = [];
      _shiftOptions.forEach((key, value) { schedule.add(value); });

//yield SelectPersonPINVerified(staff: event.staff, nextShift: _nextShift);
      //    QR.params.   .ensureExist('employee', initValue: event.staff, )
      // QR.params['employee'] = this.employee;
      // QR.params['employee']!.keepAlive = true;

      // if (null != _nextShift) {
      //   QR.params['shift'] = _nextShift;
      //   QR.params['shift']!.keepAlive = true;
      // }

      // QR.navigator.replaceAll('/home/clockIn');
      yield TimeClockStateClockingIn(_nextShift, _positions, schedule);
    }


    }
  }
}
