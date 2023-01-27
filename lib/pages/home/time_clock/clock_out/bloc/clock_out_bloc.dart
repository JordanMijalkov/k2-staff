import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:k2_flutter_api/api/core_api_service.dart';
import 'package:k2_flutter_api/api/k2_core_api_client.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/pages/home/time_clock/clock_in/staff_time_entry_mixin.dart';
import 'package:qlevar_router/qlevar_router.dart';

part 'clock_out_event.dart';
part 'clock_out_state.dart';

class ClockOutBloc extends Bloc<ClockOutEvent, ClockOutState> with StaffTimeEntryHelpers {
    ClockOutBloc({required this.employee, required this.centerId}) : super(ClockOutInitial());
  final String? centerId;
  final K2StaffProfile employee;

  final CoreApiService? coreApiService = app<K2CoreApiClient>();
  
  @override
  Stream<ClockOutState> mapEventToState(ClockOutEvent event,) async* {
    if (event is ClockOutResumeOrBreak) {
      yield* _mapResumeOrBreakToState(event);
    } else if (event is ClockOutRequestedEvent) {
      yield* _mapClockOutToState(event);
    }


  }

  Stream<ClockOutState> _mapResumeOrBreakToState(ClockOutResumeOrBreak event) async* {
          await coreApiService!.clockIn(
              personId: event.employeeId!,
              centerId: event.centerId!,
              positionId: event.positionId!,
              type: event.type,
              shiftId: event.shiftId,
              scheduleId: event.scheduleId);
          final _currentTimeEntries =
              await getTimeEntries(event.employeeId!, event.centerId!);

              QR.params['timeEntry'] = event.timeEntry!;
              QR.params['timeEntry']!.keepAlive = true;              

              QR.params['startBreak'] = event.startBreak!;
              QR.params['startBreak']!.keepAlive = true;

              QR.params['logEntries'] = getLogSummaryItems(_currentTimeEntries.entries
                      .map((v) => (v.value))
                      .toList());
              QR.params['logEntries']!.keepAlive = true;  

              if (null != event.shift) {
                QR.params['selectedShift'] = event.shift!;
                QR.params['selectedShift']!.keepAlive = true;
              }

              QR.navigator.replaceAll('/home/clockInOutSuccess');

          // yield KioskNavStateClockOutOrBreakSuccess(
          //     employee: event.employee,
          //     timeEntry: event.timeEntry,
          //     startBreak: event.startBreak,
          //     logEntries: getLogSummaryItems(
          //         _currentTimeEntries.entries.map((v) => (v.value)).toList()),
          //     selectedShift: _selectedShift);
              
          // break;
  }

  Stream<ClockOutState> _mapClockOutToState(ClockOutRequestedEvent event) async* {
              await coreApiService!
              .clockOut(event.timeEntry!.id!);
          final _currentTimeEntries =
              await getTimeEntries(this.employee.id, event.centerId!);
       
              QR.params['timeEntry'] = event.timeEntry!;
              QR.params['timeEntry']!.keepAlive = true;              

              QR.params['startBreak'] = K2ClockOutType.ClockOut;
              QR.params['startBreak']!.keepAlive = true;

              QR.params['logEntries'] = getLogSummaryItems(_currentTimeEntries.entries
                      .map((v) => (v.value))
                      .toList());
              QR.params['logEntries']!.keepAlive = true;  

              if (null != event.shift) {
                QR.params['selectedShift'] = event.shift!;
                QR.params['selectedShift']!.keepAlive = true;
              }

              QR.navigator.replaceAll('/home/clockInOutSuccess');

          // yield KioskNavStateClockOutOrBreakSuccess(
          //     employee: _event.employee,
          //     timeEntry: _event.timeEntry,
          //     startBreak: K2ClockOutType.ClockOut,
          //     shift: _event.shift,
          //     logEntries: _getLogSummaryItems(
          //         _currentTimeEntries.entries.map((v) => (v.value)).toList()),
          //     selectedShift: _selectedShift);
  }

}
