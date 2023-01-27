import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:k2_flutter_api/api/core_api_service.dart';
import 'package:k2_flutter_api/api/k2_core_api_client.dart';
import 'package:k2_flutter_api/k2_flutter_util_data_models.dart';
import 'package:k2_staff/core/error_handlers.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/pages/home/time_clock/clock_in/staff_time_entry_mixin.dart';
import 'package:qlevar_router/qlevar_router.dart';

part 'clock_in_event.dart';
part 'clock_in_state.dart';

class ClockInBloc extends Bloc<ClockInEvent, ClockInState> with StaffTimeEntryHelpers {
  ClockInBloc({required this.employee, required this.centerId}) : super(ClockInInitial());
  final String? centerId;
  final K2StaffProfile employee;

  final CoreApiService? coreApiService = app<K2CoreApiClient>();
  final DateFormat dateFormatter = new DateFormat('yyyy-MM-dd');

 

  Future<Map<String?, K2Position>> _getPositionsForPerson(String id) async {
    Map<String?, K2Position> _positionMap = new Map();
    _positionMap = await coreApiService!.getPositionsForPerson(id).then((qr) {
      List<dynamic> _positions = qr!.data!['getStaff']['positions'];
      for (var _p in _positions) {
        _positionMap[_p['id']] = K2Position(id: _p['id'], title: _p['title']);
      }
      return _positionMap;
    }).catchError(apiErrorHandler);
    return _positionMap;
  }

  
  @override
  Stream<ClockInState> mapEventToState(
    ClockInEvent event,
  ) async* {
    if (event is ClockInForUnscheduledShift) yield* _mapUnscheduledShiftToState(event);
    else if (event is ClockInForScheduledShift) yield* _mapScheduledShiftToState(event);
  }

  Stream<ClockInState> _mapUnscheduledShiftToState(ClockInForUnscheduledShift event) async* {
          // Gather the info
          final _person = this.employee;

          // If we have been given a position, clock into it
          if (event.position != null) {
//            try {
              await coreApiService!.clockIn(
                  personId: _person.id,
                  centerId: this.centerId!,
                  positionId: event.position!.id!,
                  type: 'UNSCHEDULED',
                  shiftId: null,
                  scheduleId: null).catchError(apiErrorHandler);
            // } catch (error) {
            //   yield KioskNavStateFailure(
            //       message: "Sorry, there was a problem. Please try again.");
            //   break;
            // }
            final _currentTimeEntries =
                await getTimeEntries(_person.id, this.centerId!);

              QR.params['position'] = event.position!;
              QR.params['position']!.keepAlive = true;              
              
              QR.params['logEntries'] = getLogSummaryItems(_currentTimeEntries.entries
                      .map((v) => (v.value))
                      .toList());
              QR.params['logEntries']!.keepAlive = true;  

              // QR.params['selectedShift'] = null;
              // QR.params['selectedShift']!.keepAlive = true;
         
              QR.navigator.replaceAll('/home/clockInSuccess');

            // yield KioskNavStateSuccess(
            //     employee: _person,
            //     position: event.position,
            //     logEntries: _getLogSummaryItems(
            //         _currentTimeEntries.entries.map((v) => (v.value)).toList()),
            //     selectedShift: _selectedShift);
          } else {
            // If we don't have a position, we need to select one.

            // Only make the network call if needed.
            final _positions = await _getPositionsForPerson(_person.id);

            // If we only have one position, use that one
            if (_positions.length == 0) {
              yield ClockInNoPositionsError();
                  // message:
                  //     "Selected Employee has no Positions to clock in to!");
            } else if (_positions.length == 1) {
              await coreApiService!.clockIn(
                  personId: _person.id,
                  centerId: this.centerId!,
                  positionId: _positions.keys.first!,
                  type: 'UNSCHEDULED',
                  shiftId: null,
                  scheduleId: null).catchError(apiErrorHandler);

              final _currentTimeEntries =
                  await getTimeEntries(_person.id, this.centerId!);

              QR.params['position'] = _positions.values.first;
              QR.params['position']!.keepAlive = true;              
              
              QR.params['logEntries'] = getLogSummaryItems(_currentTimeEntries.entries
                      .map((v) => (v.value))
                      .toList());
              QR.params['logEntries']!.keepAlive = true;  

              // QR.params['selectedShift'] = null;
              // QR.params['selectedShift']!.keepAlive = true;
         
         
              QR.navigator.replaceAll('/home/clockInSuccess');
              // yield KioskNavStateSuccess(
              //     employee: _person,
              //     position: _positions.values.first,
              //     logEntries: _getLogSummaryItems(_currentTimeEntries.entries
              //         .map((v) => (v.value))
              //         .toList()),
              //     selectedShift: _selectedShift);


            } else {

              yield ClockInSelectPosition(positions: _positions);
              // QR.params['employee'] = _person;
              // QR.params['employee'].keepAlive = true;

              // QR.params['positionMap'] = _positions;
              // QR.params['positionMap'].keepAlive = true;   

              // QR.navigator.replaceAll('/position');
              // Assuming we haven't been passed a position (yet),
              // and there is more than one to choose from,
              // provide some options.
              // yield KioskNavStatePositionSelectClockIn(
              //     employee: _person, positionMap: _positions);
            }
          }
  }

    Stream<ClockInState> _mapScheduledShiftToState(ClockInForScheduledShift event) async* {
          final _employee = this.employee;
          final _centerId = this.centerId!;
          final _position = event.position!;
          final _type = event.type;
          final _shiftId = event.selectedShift!.id;
          final _scheduleId = event.scheduleId;
          final _selectedShift = event.selectedShift!;


            await coreApiService!.clockIn(
                personId: _employee.id,
                centerId: _centerId,
                positionId: _position.id!,
                type: _type,
                shiftId: _shiftId,
                scheduleId: _scheduleId).catchError(apiErrorHandler);
          
          final _currentTimeEntries =
              await getTimeEntries(_employee.id, _centerId); 

              QR.params['position'] = _position;
              QR.params['position']!.keepAlive = true;              
              
              QR.params['logEntries'] = getLogSummaryItems(_currentTimeEntries.entries
                      .map((v) => (v.value))
                      .toList());
              QR.params['logEntries']!.keepAlive = true;  

              QR.params['selectedShift'] = _selectedShift;
              QR.params['selectedShift']!.keepAlive = true;
         
         
              QR.navigator.replaceAll('/home/clockInSuccess');                                 
    }
}
